// app/shader/[id]/page.tsx
import Link from "next/link";
import { ShaderCanvas } from "@/components/ShaderCanvas";
import fs from "fs/promises";
import path from "path";
import CanvasWithSliders from "@/components/CanvasWithSliders";

async function getShader(id: string) {
  const shaderPath = path.join(
    process.cwd(),
    "public",
    "shaders",
    `${id}.glsl`
  );
  const code = await fs.readFile(shaderPath, "utf-8");
  return {
    id,
    name: id.replace(/-/g, " ").replace(/\b\w/g, (l) => l.toUpperCase()),
    code,
  };
}

export default async function ShaderDetail({
  params,
}: {
  params: { id: string };
}) {
  const shader = await getShader(params.id);

  return (
    <div className="container mx-auto px-4 py-8 max-w-[700px]">
      <Link href="/" className="mb-4 inline-block">
        <span>&larr; Back to Gallery</span>
      </Link>
      <h1 className="text-5xl font-bold my-8">{shader.name}</h1>
      <CanvasWithSliders shader={shader} />

      <h2 className="text-2xl font-semibold mb-2">Shader Code:</h2>
      <pre className="bg-gray-800 text-white p-4 rounded-lg overflow-x-auto">
        <code>{shader.code}</code>
      </pre>
    </div>
  );
}
