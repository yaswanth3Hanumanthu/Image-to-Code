// Function to auto-detect backend URLs based on environment
function getBackendUrl(protocol: 'http' | 'ws'): string {
  const port = 7001;
  
  // Check environment variables first
  if (protocol === 'ws' && import.meta.env.VITE_WS_BACKEND_URL) {
    return import.meta.env.VITE_WS_BACKEND_URL;
  }
  if (protocol === 'http' && import.meta.env.VITE_HTTP_BACKEND_URL) {
    return import.meta.env.VITE_HTTP_BACKEND_URL;
  }
  
  // Auto-detect environment
  const hostname = window.location.hostname;
  
  // GitHub Codespaces detection
  if (hostname.includes('.app.github.dev')) {
    const codespaceMatch = hostname.match(/([^-]+)-5173\.app\.github\.dev/);
    if (codespaceMatch) {
      const codespace = codespaceMatch[1];
      return protocol === 'ws' 
        ? `wss://${codespace}-${port}.app.github.dev`
        : `https://${codespace}-${port}.app.github.dev`;
    }
  }
  
  // Gitpod detection
  if (hostname.includes('.gitpod.io')) {
    const baseUrl = hostname.replace('5173-', `${port}-`);
    return protocol === 'ws'
      ? `wss://${baseUrl}`
      : `https://${baseUrl}`;
  }
  
  // Local development fallback
  return protocol === 'ws' 
    ? `ws://localhost:${port}`
    : `http://localhost:${port}`;
}

// Default to false if set to anything other than "true" or unset
export const IS_RUNNING_ON_CLOUD =
  import.meta.env.VITE_IS_DEPLOYED === "true" || false;

export const WS_BACKEND_URL = getBackendUrl('ws');
export const HTTP_BACKEND_URL = getBackendUrl('http');

export const PICO_BACKEND_FORM_SECRET =
  import.meta.env.VITE_PICO_BACKEND_FORM_SECRET || null;
