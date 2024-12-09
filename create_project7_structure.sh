#!/bin/bash

# Define project and app names
PROJECT_NAME="project7"
APP_NAME="accounts"

# Create the Django project
echo "Creating Django project: $PROJECT_NAME"
django-admin startproject $PROJECT_NAME
cd $PROJECT_NAME || exit

# Create the app
echo "Creating app: $APP_NAME"
python manage.py startapp $APP_NAME

# Create folders for templates and static files
echo "Creating templates and static directories..."
mkdir -p $APP_NAME/templates/$APP_NAME
mkdir -p $APP_NAME/static/$APP_NAME

# Add the app to INSTALLED_APPS in settings.py
SETTINGS_FILE="$PROJECT_NAME/settings.py"
echo "Updating INSTALLED_APPS in settings.py..."
sed -i "/INSTALLED_APPS = \[/a \ \ \ \ '$APP_NAME'," $SETTINGS_FILE

# Add static files configuration in settings.py
echo "Adding static files settings..."
echo "
# Static files settings
STATIC_URL = '/static/'
STATICFILES_DIRS = [ BASE_DIR / 'static' ]
" >> $SETTINGS_FILE

# Create the app's urls.py
echo "Creating $APP_NAME/urls.py..."
cat <<EOL > $APP_NAME/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('', views.login_view, name='login'),
]
EOL

# Include app URLs in the project's urls.py
PROJECT_URLS="$PROJECT_NAME/urls.py"
echo "Updating project URLs..."
sed -i "/urlpatterns = \[/a \ \ \ \ path('', include('$APP_NAME.urls'))," $PROJECT_URLS
sed -i "1 a from django.urls import include" $PROJECT_URLS

# Create the views.py file for the login view
echo "Creating $APP_NAME/views.py..."
cat <<EOL > $APP_NAME/views.py
from django.shortcuts import render

def login_view(request):
    return render(request, '$APP_NAME/login.html')
EOL

# Create the login.html template
echo "Creating login.html template..."
cat <<EOL > $APP_NAME/templates/$APP_NAME/login.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="{% static '$APP_NAME/styles.css' %}">
</head>
<body>
    <div class="container">
        <div class="login-box">
            <h1>Login</h1>
            <form method="POST">
                {% csrf_token %}
                <label for="nickname">Nickname:</label>
                <input type="text" id="nickname" name="nickname" placeholder="Enter your nickname" required>
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required>
                <button type="submit">Login</button>
            </form>
        </div>
    </div>
</body>
</html>
EOL

# Create the CSS file for styling
echo "Creating styles.css..."
cat <<EOL > $APP_NAME/static/$APP_NAME/styles.css
/* General styling */
body {
    margin: 0;
    padding: 0;
    font-family: Arial, sans-serif;
    background-color: #001f3f; /* Dark blue color */
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

/* Container for the login box */
.container {
    text-align: center;
    color: white;
}

/* Login box styling */
.login-box {
    background-color: white;
    padding: 30px;
    border-radius: 8px;
    width: 300px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.login-box h1 {
    margin-bottom: 20px;
    color: #001f3f; /* Dark blue for the text */
}

/* Form fields */
form {
    display: flex;
    flex-direction: column;
}

form label {
    margin-bottom: 5px;
    color: #001f3f;
    text-align: left;
}

form input {
    margin-bottom: 15px;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

form button {
    background-color: #001f3f;
    color: white;
    padding: 10px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

form button:hover {
    background-color: #0056b3;
}
EOL

# Run migrations
echo "Running migrations..."
python manage.py makemigrations
python manage.py migrate

# Done
echo "Project $PROJECT_NAME with app $APP_NAME has been set up successfully!"
echo "Run the server with: python manage.py runserver"
