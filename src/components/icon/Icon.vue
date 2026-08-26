<script setup lang="ts">
import folderRaw from "../../assets/icons/folder.svg?raw";
import folderAddRaw from "../../assets/icons/folder--add.svg?raw";
import subtractAltRaw from "../../assets/icons/subtract--alt.svg?raw";
import informationRaw from "../../assets/icons/information.svg?raw";

type IconName = "folder" | "folder-add" | "subtract-alt" | "information";

const props = withDefaults(defineProps<{ name: IconName; size?: number }>(), {
  size: 16,
});

// Strips the source file down to its geometry (paths/polygons) so it can be
// re-mounted under our own <svg fill="currentColor">, letting icon color
// follow the surrounding text/hover state instead of the exported black fill.
function extractIconBody(svg: string) {
  return svg
    .replace(/<\?xml[^>]*\?>/g, "")
    .replace(/<!--[\s\S]*?-->/g, "")
    .replace(/<style[\s\S]*?<\/style>/gi, "")
    .replace(/<title>[\s\S]*?<\/title>/gi, "")
    .replace(/<defs>[\s\S]*?<\/defs>/gi, "")
    .replace(/<rect[^>]*Transparent_Rectangle[^>]*\/>/gi, "")
    .match(/<svg[^>]*>([\s\S]*)<\/svg>/i)?.[1]
    .trim() ?? "";
}

const bodies: Record<IconName, string> = {
  folder: extractIconBody(folderRaw),
  "folder-add": extractIconBody(folderAddRaw),
  "subtract-alt": extractIconBody(subtractAltRaw),
  information: extractIconBody(informationRaw),
};
</script>

<template>
  <svg
    :width="props.size"
    :height="props.size"
    viewBox="0 0 32 32"
    fill="currentColor"
    aria-hidden="true"
    v-html="bodies[props.name]"
  />
</template>
