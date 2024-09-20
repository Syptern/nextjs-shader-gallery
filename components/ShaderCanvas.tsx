"use client";

import { Resize } from "@react-three/drei";
import { Canvas, ThreeEvent, useFrame, useThree } from "@react-three/fiber";
import { useMemo, useRef, useState, useEffect } from "react";
import * as THREE from "three";

function ShaderMesh({
  code,
  input1,
  input2,
}: {
  code: string;
  input1: number;
  input2: number;
}) {
  const matRef = useRef(null);
  // This reference gives us direct access to the THREE.Mesh object
  const ref = useRef(null);
  const { size } = useThree();

  const uniforms = useMemo(() => {
    return {
      u_time: { value: 0 },
      u_resolution: {
        value: new THREE.Vector2(size.height, size.width),
      },
      u_mouse: { value: new THREE.Vector2() },
      u_input1: { value: 1 },
      u_input2: { value: 1 },
    };
  }, []);

  const handleWindowMouseMove = (event: ThreeEvent<PointerEvent>) => {
    if (matRef.current != null) {
      // @ts-ignore
      matRef.current.uniforms.u_mouse.value = new THREE.Vector2(
        event.offsetX,
        size.height - event.offsetY
      );
    }
  };

  useFrame(() => {
    if (matRef.current != null) {
      // @ts-ignore
      matRef.current.uniforms.u_time.value =
        // @ts-ignore
        matRef.current.uniforms.u_time.value + 0.01;
    }
  });

  useEffect(() => {
    console.log("test");
    if (matRef.current != null) {
      // @ts-ignore
      matRef.current.uniforms.u_input1.value = input1;
    }
  }, [input1]);

  useEffect(() => {
    if (matRef.current != null) {
      // @ts-ignore
      matRef.current.uniforms.u_input2.value = input2;
    }
  }, [input2]);

  return (
    <mesh
      ref={ref}
      scale={[size.height, size.width, 1]}
      onPointerMove={handleWindowMouseMove}
    >
      <planeGeometry />
      <shaderMaterial ref={matRef} fragmentShader={code} uniforms={uniforms} />
    </mesh>
  );
}

export function ShaderCanvas({
  code,
  disableRender,
  input1 = 1,
  input2 = 1,
}: {
  code: string;
  disableRender?: boolean;
  input1?: number;
  input2?: number;
}) {
  return (
    <Canvas frameloop={disableRender ? "demand" : "always"} flat dpr={1}>
      <ambientLight />
      <ShaderMesh code={code} input1={input1} input2={input2} />
    </Canvas>
  );
}
