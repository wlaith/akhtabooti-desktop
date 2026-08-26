<script setup lang="ts">
import folderRaw from "../../assets/icons/folder.svg?raw";
import folderAddRaw from "../../assets/icons/folder--add.svg?raw";
import subtractAltRaw from "../../assets/icons/subtract--alt.svg?raw";
import informationRaw from "../../assets/icons/information.svg?raw";
import chevronDownRaw from "../../assets/icons/chevron--down.svg?raw";
import chevronUpRaw from "../../assets/icons/chevron--up.svg?raw";
import checkmarkOutlineRaw from "../../assets/icons/step-completed.svg?raw";

type IconName =
  | "folder"
  | "folder-add"
  | "subtract-alt"
  | "information"
  | "chevron-down"
  | "chevron-up"
  | "checkmark-outline";

const props = withDefaults(defineProps<{ name: IconName; size?: number }>(), {
  size: 16,
});

// Strips each source file down to its geometry (paths/polygons) so it can be
// re-mounted under our own <svg fill="currentColor">, letting icon color
// follow the surrounding text/hover state instead of the exported fill.
function parseIcon(svg: string) {
  const viewBox = svg.match(/viewBox="([^"]+)"/)?.[1] ?? "0 0 32 32";
  const body =
    svg
      .replace(/<\?xml[^>]*\?>/g, "")
      .replace(/<!--[\s\S]*?-->/g, "")
      .replace(/<style[\s\S]*?<\/style>/gi, "")
      .replace(/<title>[\s\S]*?<\/title>/gi, "")
      .replace(/<defs>[\s\S]*?<\/defs>/gi, "")
      .replace(/<rect[^>]*Transparent_Rectangle[^>]*\/>/gi, "")
      .replace(/<rect[^>]*mix-blend-mode:multiply[^>]*\/>/gi, "")
      .replace(/\sfill="#[0-9a-fA-F]{3,8}"/g, "")
      .replace(/\sid="[^"]*"/g, "")
      .match(/<svg[^>]*>([\s\S]*)<\/svg>/i)?.[1]
      ?.trim() ?? "";
  return { viewBox, body };
}

const icons: Record<IconName, { viewBox: string; body: string }> = {
  folder: parseIcon(folderRaw),
  "folder-add": parseIcon(folderAddRaw),
  "subtract-alt": parseIcon(subtractAltRaw),
  information: parseIcon(informationRaw),
  "chevron-down": parseIcon(chevronDownRaw),
  "chevron-up": parseIcon(chevronUpRaw),
  "checkmark-outline": parseIcon(checkmarkOutlineRaw),
};
</script>

<template>
  <svg
    :width="props.size"
    :height="props.size"
    :viewBox="icons[props.name].viewBox"
    fill="currentColor"
    aria-hidden="true"
    v-html="icons[props.name].body"
  />
</template>
