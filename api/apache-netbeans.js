import fetch from "node-fetch";

export default async function handler(req, res) {
  try {
    const githubUrl =
      "https://github.com/mrshah63/my-apt-repo/releases/download/v1.0/apache-netbeans_25-1_all.deb";

    const response = await fetch(githubUrl);

    if (!response.ok) {
      return res.status(response.status).send("Failed to fetch .deb from GitHub");
    }

    // Set headers for APT client
    res.setHeader("Content-Type", "application/vnd.debian.binary-package");
    res.setHeader("Content-Disposition", "attachment; filename=apache-netbeans_25-1_all.deb");
    res.setHeader("Cache-Control", "public, max-age=0, must-revalidate");

    // Stream the response to the client
    response.body.pipe(res);
  } catch (err) {
    console.error(err);
    res.status(500).send("Internal Server Error");
  }
}
