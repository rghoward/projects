from team075_main import application
from flask_cors import CORS

if __name__ == "__main__":
    CORS(application)
    application.run()
