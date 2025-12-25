@echo off

REM ===== CONFIGURE THESE =====
SET PROJECT_NAME=sales-analytics-project
SET GITHUB_REPO_URL=https://github.com/luminous-of-faith/sales-analytics-project.git
SET BRANCH_NAME=main
REM ===========================

cd %PROJECT_NAME%

echo Initializing git repository...
git init

echo Setting default branch...
git branch -M %BRANCH_NAME%

echo Adding remote origin...
git remote add origin %GITHUB_REPO_URL%

echo Adding files to git...
git add .

echo Creating initial commit...
git commit -m "Initial project structure for sales analytics project"

echo Pushing to GitHub...
git push -u origin %BRANCH_NAME%

echo.
echo GitHub configuration complete.
pause
