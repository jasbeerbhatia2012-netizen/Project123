# app.py (Modified to fail security scan)
import os

def execute_command(user_input):
    # Bandit will flag this as a critical security vulnerability (shell injection risk)
    os.system(f"echo {user_input}") 
