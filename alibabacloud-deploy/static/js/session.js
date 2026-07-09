// Session Management and Timer
(function() {
    'use strict';

    // Configuration
    const CONFIG = {
        checkInterval: 1000, // Check session every 1 second
        warningThreshold: 300, // Show warning at 5 minutes
        redirectTimeout: 60000 // Redirect after 1 minute of inactivity
    };

    class SessionManager {
        constructor() {
            this.sessionTimer = null;
            this.warningShown = false;
            this.init();
        }

        init() {
            this.updateSessionTimer();
            setInterval(() => this.updateSessionTimer(), CONFIG.checkInterval);
            
            // Add activity listeners
            document.addEventListener('click', () => this.resetInactivityTimer());
            document.addEventListener('keypress', () => this.resetInactivityTimer());
            document.addEventListener('mousemove', () => this.resetInactivityTimer());
        }

        updateSessionTimer() {
            // Fetch session info from API endpoint
            fetch('/api/session-info', {
                method: 'GET',
                credentials: 'same-origin'
            })
            .then(response => {
                if (response.status === 401) {
                    this.handleSessionExpired();
                    return null;
                }
                return response.json();
            })
            .then(data => {
                if (data && data.remaining_seconds !== undefined) {
                    this.updateTimerDisplay(data.remaining_seconds);
                    this.checkWarningThreshold(data.remaining_seconds);
                }
            })
            .catch(error => {
                console.error('Error fetching session info:', error);
            });
        }

        updateTimerDisplay(seconds) {
            const minutes = Math.floor(seconds / 60);
            const secs = seconds % 60;
            
            const timerElement = document.getElementById('sessionTime');
            if (timerElement) {
                timerElement.textContent = this.formatTime(minutes, secs);
            }

            // Update color based on remaining time
            this.updateTimerColor(minutes, secs);
        }

        formatTime(minutes, seconds) {
            return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
        }

        updateTimerColor(minutes, seconds) {
            const timerElement = document.getElementById('sessionTime');
            if (!timerElement) return;

            const totalSeconds = minutes * 60 + seconds;
            
            if (totalSeconds <= 300) { // Less than 5 minutes
                timerElement.style.color = '#dc2626';
            } else if (totalSeconds <= 600) { // Less than 10 minutes
                timerElement.style.color = '#ea580c';
            } else {
                timerElement.style.color = '#667eea';
            }
        }

        checkWarningThreshold(seconds) {
            if (seconds <= CONFIG.warningThreshold && !this.warningShown) {
                this.showWarning();
                this.warningShown = true;
            } else if (seconds > CONFIG.warningThreshold) {
                this.warningShown = false;
            }

            if (seconds <= 0) {
                this.handleSessionExpired();
            }
        }

        showWarning() {
            const warning = document.createElement('div');
            warning.id = 'sessionWarning';
            warning.className = 'session-warning';
            warning.innerHTML = `
                <div class="warning-content">
                    <strong>⚠ Session Expiring Soon</strong>
                    <p>Your session will expire in less than 5 minutes due to inactivity.</p>
                    <button onclick="location.reload()">Refresh Session</button>
                </div>
            `;
            
            // Add styles
            const style = document.createElement('style');
            style.textContent = \`
                .session-warning {
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    background: #fff3cd;
                    border: 1px solid #ffc107;
                    border-radius: 8px;
                    padding: 16px;
                    max-width: 400px;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                    z-index: 9999;
                    animation: slideIn 0.3s ease;
                }

                .warning-content {
                    color: #856404;
                    font-size: 14px;
                }

                .warning-content strong {
                    display: block;
                    margin-bottom: 8px;
                }

                .warning-content p {
                    margin: 0 0 12px 0;
                }

                .warning-content button {
                    background: #ffc107;
                    color: #333;
                    border: none;
                    padding: 6px 16px;
                    border-radius: 4px;
                    cursor: pointer;
                    font-weight: 500;
                    transition: all 0.2s ease;
                }

                .warning-content button:hover {
                    background: #ffb800;
                    transform: translateY(-1px);
                }

                @keyframes slideIn {
                    from {
                        opacity: 0;
                        transform: translateX(20px);
                    }
                    to {
                        opacity: 1;
                        transform: translateX(0);
                    }
                }
            \`;
            
            if (!document.getElementById('warningStyles')) {
                style.id = 'warningStyles';
                document.head.appendChild(style);
            }

            // Remove existing warning if present
            const existing = document.getElementById('sessionWarning');
            if (existing) {
                existing.remove();
            }

            document.body.appendChild(warning);
        }

        handleSessionExpired() {
            // Hide warning
            const warning = document.getElementById('sessionWarning');
            if (warning) {
                warning.remove();
            }

            // Show expiration message
            const expiredMsg = document.createElement('div');
            expiredMsg.id = 'sessionExpired';
            expiredMsg.className = 'session-expired';
            expiredMsg.innerHTML = `
                <div class="expired-content">
                    <h3>Session Expired</h3>
                    <p>Your session has expired for security reasons. Please log in again.</p>
                    <a href="/login">Return to Login</a>
                </div>
            `;

            const style = document.createElement('style');
            style.textContent = \`
                .session-expired {
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0, 0, 0, 0.5);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    z-index: 10000;
                }

                .expired-content {
                    background: white;
                    padding: 40px;
                    border-radius: 12px;
                    text-align: center;
                    max-width: 400px;
                }

                .expired-content h3 {
                    color: #dc2626;
                    margin: 0 0 12px 0;
                }

                .expired-content p {
                    color: #666;
                    margin: 0 0 20px 0;
                    line-height: 1.5;
                }

                .expired-content a {
                    display: inline-block;
                    background: #667eea;
                    color: white;
                    padding: 10px 30px;
                    border-radius: 6px;
                    text-decoration: none;
                    font-weight: 600;
                    transition: background 0.2s ease;
                }

                .expired-content a:hover {
                    background: #764ba2;
                }
            \`;

            if (!document.getElementById('expiredStyles')) {
                style.id = 'expiredStyles';
                document.head.appendChild(style);
            }

            document.body.appendChild(expiredMsg);

            // Disable all interactions
            document.body.style.pointerEvents = 'none';
            document.body.style.opacity = '0.5';
        }

        resetInactivityTimer() {
            // Activity detected - session will be refreshed on next check
            // This is handled server-side with before_request
        }
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new SessionManager();
        });
    } else {
        new SessionManager();
    }
})();
