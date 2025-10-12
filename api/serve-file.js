import fetch from 'node-fetch';

export default async function handler(req, res) {
  const file = req.query.file;
  const url = `https://github.com/mrshah63/my-apt-repo/releases/download/v1.0/${file}`;
  const response = await fetch(url);
  if (!response.ok) return res.status(404).send('Not found');
  
  res.setHeader('Content-Type', 'application/x-debian-package');
  response.body.pipe(res);
}
