const express = require("express");

const app = express();

app.get("/", (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Supplier Directory</title>

      <style>
        body {
          font-family: Arial, sans-serif;
          max-width: 900px;
          margin: 50px auto;
          padding: 20px;
          background: #f5f5f5;
        }

        h1 {
          color: #232f3e;
        }

        .card {
          background: white;
          padding: 25px;
          border-radius: 8px;
          margin-top: 20px;
        }

        button {
          padding: 10px 20px;
          cursor: pointer;
        }

        #status {
          margin-top: 15px;
          font-weight: bold;
        }
      </style>
    </head>

    <body>

      <h1>Supplier Directory</h1>

      <div class="card">
        <h2>Application Status</h2>

        <p>Frontend container is running.</p>

        <button onclick="checkDatabase()">
          Check Database Connection
        </button>

        <p id="status"></p>
      </div>

      <script>
        async function checkDatabase() {
          const status = document.getElementById("status");

          status.innerText = "Checking database...";

          try {
            const response = await fetch("/api/db");
            const data = await response.json();

            if (response.ok) {
              status.innerText =
                "Database connected successfully. Server time: " + data.time;
            } else {
              status.innerText =
                "Database connection failed: " + data.error;
            }

          } catch (error) {
            status.innerText =
              "Unable to reach backend: " + error.message;
          }
        }
      </script>

    </body>
    </html>
  `);
});

app.listen(3000, "0.0.0.0", () => {
  console.log("Frontend running on port 3000");
});