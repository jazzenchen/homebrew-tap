#!/usr/bin/env node
// Points Casks/agent-hud.rb at the newest Agent HUD release on
// jazzenchen/agent-hud-open, betas included, that has both Mac DMGs and a
// SHA256SUMS file. Writes the cask only when something changed.
import { readFileSync, writeFileSync } from "node:fs";

const repo = "jazzenchen/agent-hud-open";
const caskFile = new URL("../../Casks/agent-hud.rb", import.meta.url);
const headers = {
  accept: "application/vnd.github+json",
  "user-agent": "agent-hud-homebrew-tap",
};
if (process.env.GITHUB_TOKEN) {
  headers.authorization = `Bearer ${process.env.GITHUB_TOKEN}`;
}

async function get(url) {
  const response = await fetch(url, { headers });
  if (!response.ok) throw new Error(`${url} answered HTTP ${response.status}`);
  return response;
}

// Orders X.Y.Z and X.Y.Z-beta.N: a beta comes before its release, and
// numeric parts compare as numbers (beta.10 after beta.9).
function compareVersions(a, b) {
  const split = (version) => {
    const [main, pre] = version.split("-", 2);
    return { main: main.split(".").map(Number), pre: pre ? pre.split(".") : [] };
  };
  const left = split(a);
  const right = split(b);
  for (let i = 0; i < 3; i += 1) {
    const difference = (left.main[i] ?? 0) - (right.main[i] ?? 0);
    if (difference) return Math.sign(difference);
  }
  if (!left.pre.length || !right.pre.length) {
    return Math.sign(right.pre.length - left.pre.length);
  }
  for (let i = 0; i < Math.max(left.pre.length, right.pre.length); i += 1) {
    const x = left.pre[i];
    const y = right.pre[i];
    if (x === undefined || y === undefined) return x === undefined ? -1 : 1;
    const numeric = /^\d+$/.test(x) && /^\d+$/.test(y);
    const difference = numeric ? Number(x) - Number(y) : x.localeCompare(y);
    if (difference) return Math.sign(difference);
  }
  return 0;
}

const dmg = (version, arch) => `Agent-HUD-${version}-${arch}.dmg`;

const releases = await (await get(`https://api.github.com/repos/${repo}/releases?per_page=30`)).json();
const newest = releases
  .filter((release) => !release.draft)
  .map((release) => ({
    version: release.tag_name.replace(/^v/, ""),
    names: new Set(release.assets.map((asset) => asset.name)),
  }))
  .filter(
    ({ version, names }) =>
      names.has(dmg(version, "arm64")) && names.has(dmg(version, "x86_64")) && names.has("SHA256SUMS"),
  )
  .sort((a, b) => compareVersions(b.version, a.version))[0];
if (!newest) throw new Error(`No release on ${repo} has both Mac DMGs and SHA256SUMS`);

const { version } = newest;
const sums = new Map(
  (await (await get(`https://github.com/${repo}/releases/download/v${version}/SHA256SUMS`)).text())
    .split("\n")
    .map((line) => line.trim().match(/^([0-9a-f]{64})\s+\*?(.+)$/))
    .filter(Boolean)
    .map(([, hash, name]) => [name, hash]),
);
const arm = sums.get(dmg(version, "arm64"));
const intel = sums.get(dmg(version, "x86_64"));
if (!arm || !intel) throw new Error(`SHA256SUMS of v${version} lacks a Mac DMG`);

const before = readFileSync(caskFile, "utf8");
const after = before
  .replace(/^(  version ")[^"]*(")$/m, `$1${version}$2`)
  .replace(/(sha256 arm:\s+")[0-9a-f]{64}(")/, `$1${arm}$2`)
  .replace(/(intel: ")[0-9a-f]{64}(")/, `$1${intel}$2`);
if (!after.includes(`version "${version}"`) || !after.includes(arm) || !after.includes(intel)) {
  throw new Error("Casks/agent-hud.rb no longer has the version and sha256 lines this script edits");
}
if (after === before) {
  console.log(`agent-hud is already at ${version}`);
} else {
  writeFileSync(caskFile, after);
  console.log(`agent-hud moved to ${version}`);
}
