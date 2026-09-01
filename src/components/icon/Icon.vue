<script setup lang="ts">
import folderRaw from "../../assets/icons/folder.svg?raw";
import folderAddRaw from "../../assets/icons/folder--add.svg?raw";
import subtractAltRaw from "../../assets/icons/subtract--alt.svg?raw";
import informationRaw from "../../assets/icons/information.svg?raw";
import chevronDownRaw from "../../assets/icons/chevron--down.svg?raw";
import chevronUpRaw from "../../assets/icons/chevron--up.svg?raw";
import checkmarkOutlineRaw from "../../assets/icons/step-completed.svg?raw";
import viewRaw from "../../assets/icons/view.svg?raw";
import viewOffRaw from "../../assets/icons/view--off.svg?raw";
import copyRaw from "../../assets/icons/copy.svg?raw";
import hourglassRaw from "../../assets/icons/hourglass.svg?raw";
import emailUserRaw from "../../assets/icons/email--user.svg?raw";
import phoneRaw from "../../assets/icons/phone.svg?raw";
import documentRaw from "../../assets/icons/document.svg?raw";
import documentPdfRaw from "../../assets/icons/PDF.svg?raw";
import documentDocRaw from "../../assets/icons/DOC.svg?raw";
import documentXlsRaw from "../../assets/icons/XLS.svg?raw";
import documentHtmlRaw from "../../assets/icons/HTML.svg?raw";
import documentJsonRaw from "../../assets/icons/JSON.svg?raw";
import documentTxtRaw from "../../assets/icons/TXT.svg?raw";

type IconName =
  | "folder"
  | "folder-add"
  | "subtract-alt"
  | "information"
  | "chevron-down"
  | "chevron-up"
  | "checkmark-outline"
  | "view"
  | "view-off"
  | "copy"
  | "hourglass"
  | "email-user"
  | "phone"
  | "document"
  | "document-pdf"
  | "document-doc"
  | "document-xls"
  | "document-html"
  | "document-json"
  | "document-txt";

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
  view: parseIcon(viewRaw),
  "view-off": parseIcon(viewOffRaw),
  copy: parseIcon(copyRaw),
  hourglass: parseIcon(hourglassRaw),
  "email-user": parseIcon(emailUserRaw),
  phone: parseIcon(phoneRaw),
  document: parseIcon(documentRaw),
  "document-pdf": parseIcon(documentPdfRaw),
  "document-doc": parseIcon(documentDocRaw),
  "document-xls": parseIcon(documentXlsRaw),
  "document-html": parseIcon(documentHtmlRaw),
  "document-json": parseIcon(documentJsonRaw),
  "document-txt": parseIcon(documentTxtRaw),
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
