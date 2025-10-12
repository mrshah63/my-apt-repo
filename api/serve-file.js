import fs from "fs";
import path from "path";

export default async function handler(req, res) {
  const filePath = path.join(process.cwd(), req.query.file);
  if (!fs.existsSync(filePath)) return res.status(404).send("Not found");
  
  res.setHeader("Content-Type", "application/octet-stream");
  fs.createReadStream(filePath).pipe(res);
}
