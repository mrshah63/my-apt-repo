import fetch from 'node-fetch';

export default async function handler(req, res) {
  const url = 'https://github.com/mrshah63/my-apt-repo/releases/download/v1.0/apache-netbeans_25-1_all.deb';
  
  const response = await fetch(url);
  const headers = Object.fromEntries(response.headers.entries());

  // Pass through essential headers
  res.setHeader('Content-Type', headers['content-type'] || 'application/octet-stream');
  res.setHeader('Content-Disposition', 'attachment; filename=apache-netbeans_25-1_all.deb');
  res.setHeader('Content-Length', headers['content-length'] || '');

  // Stream the file
  response.body.pipe(res);
}
