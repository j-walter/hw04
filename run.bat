@ECHO OFF
cd "calc"
cmd /c mix test
IF NOT ERRORLEVEL 1 (
    echo.
    echo.
    cmd /c mix run -e "Calc.%1"
) ELSE (
    echo "Tests failed so I won't run calc"
)