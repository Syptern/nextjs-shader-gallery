"use client";

// app/shader/[id]/page.tsx
import Link from "next/link";
import { ShaderCanvas } from "@/components/ShaderCanvas";
import { useState } from "react";
import { ShaderImport } from "@/app/api/shaders/route";
import { Slider } from "./ui/slider";

export default function CanvasWithSliders({
  shader,
}: {
  shader: ShaderImport;
}) {
  const [input1, setInput1] = useState(1);
  const [input2, setInput2] = useState(1);

  return (
    <>
      <div className="bg-white rounded-lg overflow-hidden shadow-lg mb-6">
        <div className="aspect-square w-[800px] max-w-full">
          <ShaderCanvas code={shader.code} input1={input1} input2={input2} />
        </div>
      </div>
      <div className="text-black inline-block w-40">
        <span> Input 1 </span>
        <Slider
          defaultValue={[1]}
          max={2}
          step={0.005}
          value={[input1]}
          onValueChange={(e) => setInput1(e[0])}
          className="pb-8 pt-2"
        />
        <span> Input 2 </span>
        <Slider
          defaultValue={[1]}
          max={2}
          step={0.005}
          value={[input2]}
          onValueChange={(e) => setInput2(e[0])}
          className="pb-8 pt-2"
        />{" "}
      </div>
    </>
  );
}
