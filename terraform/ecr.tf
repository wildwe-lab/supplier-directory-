resource "aws_ecr_repository" "frontend" {
  name = "supplier-directory-project-frontend"
  force_delete = true

  tags = {
    project    = "supplier-directory"
    enviroment = "dev"
  }

}
resource "aws_ecr_repository" "backend" {
  name = "supplier-directory-project-backend"
  force_delete = true

  tags = {
    project    = "supplier-directory"
    enviroment = "dev"
  }
}