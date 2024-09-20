// components/ShaderCard.tsx
"use client";

import { useState } from "react";
import { ShaderCanvas } from "./ShaderCanvas";
import { Card, CardContent, CardFooter, CardHeader } from "./ui/card";

interface ShaderCardProps {
  shader: {
    id: string;
    name: string;
    code: string;
  };
}

export function ShaderCard({ shader }: ShaderCardProps) {
  const [disableRender, setDisableRender] = useState(true);

  return (
    <div className="h-full w-full">
      <div
        className="w-full aspect-square overflow-hidden border-2 border-stone-300 relative"
        onMouseEnter={() => setDisableRender(false)}
        onMouseLeave={() => setDisableRender(true)}
      >
        {" "}
        <ShaderCanvas code={shader.code} disableRender={disableRender} />
      </div>
      <h2 className="break-all font-light text-lg py-3">{shader.name}</h2>
    </div>
  );
}
