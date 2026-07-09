import os
import secrets
from datetime import datetime, timedelta
from functools import wraps

from flask import Flask, render_template, request, session, redirect, url_for, jsonify
from dotenv import load_dotenv
import msal

from config import get_config

# Load environment variables
load_dotenv()

app = Flask(__name__)
app.config.from_object(get_config())

# Initialize MSAL app
def get_msal_app():
    return msal.PublicClientApplication(
        app.config['AZURE_CLIENT_ID'],
        authority=app.config['AZURE_AUTHORITY']
    )

def login_required(f):
    """Decorator to require login"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user' not in session:
            return redirect(url_for('login'))
        
        # Check session expiration
        if 'session_expiry' in session:
            if datetime.now() > datetime.fromisoformat(session['session_expiry']):
                session.clear()
                return redirect(url_for('login'))
        
        return f(*args, **kwargs)
    
    return decorated_function

@app.before_request
def before_request():
    """Set session as permanent and update expiry time"""
    session.permanent = True
    app.permanent_session_lifetime = timedelta(seconds=app.config['SESSION_TIMEOUT'])
    session.modified = True
    
    # Set session expiry
    if 'session_expiry' not in session:
        session['session_expiry'] = (datetime.now() + timedelta(seconds=app.config['SESSION_TIMEOUT'])).isoformat()

@app.route('/')
def index():
    """Home page - redirect to dashboard if logged in"""
    if 'user' in session:
        return redirect(url_for('dashboard'))
    return redirect(url_for('login'))

@app.route('/login', methods=['GET'])
def login():
    """Login page with Azure AD authentication"""
    if 'user' in session:
        return redirect(url_for('dashboard'))
    
    # Generate authorization request URL
    msal_app = get_msal_app()
    auth_url = msal_app.get_authorization_request_url(
        app.config['MSAL_SCOPES'],
        redirect_uri=app.config['REDIRECT_URI']
    )
    
    return render_template('login.html', auth_url=auth_url)

@app.route('/auth/callback')
def auth_callback():
    """Handle Azure AD callback"""
    # Check for authorization code
    auth_code = request.args.get('code')
    if not auth_code:
        return redirect(url_for('login'))
    
    # Exchange code for token
    msal_app = get_msal_app()
    token_response = msal_app.acquire_token_by_authorization_code(
        auth_code,
        scopes=app.config['MSAL_SCOPES'],
        redirect_uri=app.config['REDIRECT_URI']
    )
    
    if 'error' in token_response:
        return redirect(url_for('login'))
    
    # Store user info (without storing token in URL)
    # Token is stored in session server-side only
    session['user'] = {
        'name': token_response.get('id_token_claims', {}).get('name', 'User'),
        'email': token_response.get('id_token_claims', {}).get('preferred_username', ''),
        'oid': token_response.get('id_token_claims', {}).get('oid', '')
    }
    session['access_token'] = token_response.get('access_token')
    session['refresh_token'] = token_response.get('refresh_token')
    session.modified = True
    
    return redirect(url_for('dashboard'))

@app.route('/dashboard')
@login_required
def dashboard():
    """Main dashboard"""
    return render_template('dashboard.html', user=session.get('user'))

@app.route('/page_a')
@login_required
def page_a():
    """Page A - Alpha"""
    return render_template('page_a.html', 
                         page_title='Alpha',
                         page_content='α - Alpha Configuration Panel')

@app.route('/page_b')
@login_required
def page_b():
    """Page B - Beta"""
    return render_template('page_b.html',
                         page_title='Beta',
                         page_content='β - Beta Deployment Management')

@app.route('/page_c')
@login_required
def page_c():
    """Page C - Gamma"""
    return render_template('page_c.html',
                         page_title='Gamma',
                         page_content='γ - Gamma Monitoring Dashboard')

@app.route('/page_d')
@login_required
def page_d():
    """Page D - Delta"""
    return render_template('page_d.html',
                         page_title='Delta',
                         page_content='δ - Delta Log Analysis')

@app.route('/logout', methods=['POST'])
def logout():
    """Logout user"""
    session.clear()
    return redirect(url_for('login'))

@app.route('/api/session-info')
@login_required
def get_session_info():
    """API endpoint to get session info (no token in response)"""
    if 'session_expiry' in session:
        expiry = datetime.fromisoformat(session['session_expiry'])
        remaining = (expiry - datetime.now()).total_seconds()
        return jsonify({
            'user': session.get('user', {}),
            'remaining_seconds': max(0, int(remaining))
        })
    return jsonify({'error': 'Session not found'}), 401

@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors"""
    return render_template('404.html'), 404

@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors"""
    return render_template('500.html'), 500

if __name__ == '__main__':
    # For development only - use gunicorn in production
    app.run(debug=app.config['DEBUG'], host='127.0.0.1', port=5000)
