// app/api/shaders/route.ts
import { NextResponse } from "next/server";
import fs from "fs/promises";
import path from "path";

export type ShaderImport = {
  id: string;
  name: string;
  code: string;
};

export async function GET(): Promise<NextResponse<ShaderImport[]>> {
  const shaderDir = path.join(process.cwd(), "public", "shaders");
  const shaderFiles = await fs.readdir(shaderDir);

  const shaders = await Promise.all(
    shaderFiles.map(async (file) => {
      const content = await fs.readFile(path.join(shaderDir, file), "utf-8");
      return {
        id: path.parse(file).name,
        name: path
          .parse(file)
          .name.replace(/-/g, " ")
          .replace(/\b\w/g, (l) => l.toUpperCase()),
        code: content,
      };
    })
  );

  return NextResponse.json(shaders);
}
