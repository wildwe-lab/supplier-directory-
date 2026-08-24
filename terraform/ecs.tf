resource "aws_ecs_cluster" "supplier-cluster" {
  name = "supplier-cluster"
}


# FRONTEND TASK DEFINITION

resource "aws_ecs_task_definition" "frontend-task" {
  family                   = "frontend-container"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs-task-execution-role.arn

  container_definitions = jsonencode([
    {
      name      = "supplier-directory-project-frontend"
      image     = "${aws_ecr_repository.frontend.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.frontend-logs.name
          "awslogs-region"        = "ap-northeast-3"
          "awslogs-stream-prefix" = "frontend"
        }
      }
    }
  ])
}


# BACKEND TASK DEFINITION

resource "aws_ecs_task_definition" "backend-task" {
  family                   = "backend-container"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs-task-execution-role.arn

  container_definitions = jsonencode([
    {
      name      = "supplier-directory-project-backend"
      image     = "${aws_ecr_repository.backend.repository_url}:latest"
      essential = true

      environment = [
        {
          name  = "DB_HOST"
          value = aws_db_instance.supplier-db.address
        },
        {
          name  = "DB_PORT"
          value = "5432"
        },
        {
          name  = "DB_NAME"
          value = "supliersdb"
        },
        {
          name  = "DB_USER"
          value = "ahmed"
        },
        {
          name  = "DB_PASSWORD"
          value = var.db_password
        },
        {
          name  = "DB_SSL"
          value = "true"
        }
      ]

      portMappings = [
        {
          containerPort = 5000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.backend-logs.name
          "awslogs-region"        = "ap-northeast-3"
          "awslogs-stream-prefix" = "backend"
        }
      }
    }
  ])
}


# FRONTEND ECS SERVICE

resource "aws_ecs_service" "frontend-service" {
  name            = "frontend-service"
  cluster         = aws_ecs_cluster.supplier-cluster.id
  task_definition = aws_ecs_task_definition.frontend-task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.private-1a.id,
      aws_subnet.private-1b.id
    ]

    security_groups  = [aws_security_group.ecs-sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend-tg.arn
    container_name   = "supplier-directory-project-frontend"
    container_port   = 3000
  }
}


# BACKEND ECS SERVICE

resource "aws_ecs_service" "backend-service" {
  name            = "supplier-directory-project-backend"
  cluster         = aws_ecs_cluster.supplier-cluster.id
  task_definition = aws_ecs_task_definition.backend-task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.private-1a.id,
      aws_subnet.private-1b.id
    ]

    security_groups  = [aws_security_group.ecs-sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend-tg.arn
    container_name   = "supplier-directory-project-backend"
    container_port   = 5000
  }
}


