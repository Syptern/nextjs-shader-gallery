import { ShaderImport } from "@/app/api/shaders/route";
import { Link } from "lucide-react";
import { ShaderCard } from "./ShaderCard";

export const HomeGrid = ({ shaders }: { shaders: ShaderImport[] }) => {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-12">
      {shaders.map((shader: ShaderImport) => (
        <Link
          href={`/?shader=${shader.id}`}
          key={shader.id}
          className={`block`}
        >
          <ShaderCard shader={shader} />
        </Link>
      ))}
    </div>
  );
};
