// app/page.tsx
import Link from "next/link";
import { ShaderCard } from "../components/ShaderCard";
import { ShaderImport } from "./api/shaders/route";

async function getShaders() {
  const res = await fetch("http://localhost:3000/api/shaders", {
    cache: "no-store",
  });
  if (!res.ok) {
    throw new Error("Failed to fetch shaders");
  }
  return res.json();
}

export default async function Home() {
  const shaders = await getShaders();

  return (
    <div className="p-8 sm:p-12 md:p-20">
      <div className="flex pb-20">
        <div className="w-1/2">
          <h1 className="text-left text-5xl md:text-8xl">Fragment Shaders</h1>
          <span className="opacity-80 text-xl font-light">
            Fragment shaders are the artists of the GPU, painting each pixel
            with the delicate hues of light and shadow, breathing life into the
            canvas of our digital worlds.
          </span>
        </div>
        <div className="text-right ml-auto my-8 flex flex-col gap-2">
          <Link href={"/about"}>
            <span>About</span>
          </Link>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-12">
        {shaders.map((shader: ShaderImport) => (
          <Link
            href={`/shader/${shader.id}`}
            key={shader.id}
            className={`block`}
          >
            <ShaderCard shader={shader} />
          </Link>
        ))}
      </div>
    </div>
  );
}
