import { reactive, ref } from "vue";
import { invoke } from "@tauri-apps/api/core";

export interface FilePIIs {
  filename: string;
  email_accounts: string[];
  phone_numbers: string[];
  other_piis: string[];
}

export type PathStatus = "pending" | "done" | "error";

export function useScan() {
  const results = ref<FilePIIs[]>([]);
  const pathStatus = reactive<Record<string, PathStatus>>({});
  const scanning = ref(false);
  const error = ref("");
  const hasScanned = ref(false);

  async function scan(paths: string[]) {
    if (paths.length === 0) return;

    error.value = "";
    scanning.value = true;
    hasScanned.value = true;
    results.value = [];
    for (const path of paths) pathStatus[path] = "pending";

    await Promise.allSettled(
      paths.map((path) =>
        invoke<FilePIIs[]>("scan_path", { path })
          .then((found) => {
            results.value.push(...found);
            pathStatus[path] = "done";
          })
          .catch((e) => {
            pathStatus[path] = "error";
            error.value = String(e);
          }),
      ),
    );

    scanning.value = false;
  }

  function reset() {
    results.value = [];
    for (const key of Object.keys(pathStatus)) delete pathStatus[key];
    scanning.value = false;
    error.value = "";
    hasScanned.value = false;
  }

  function hasFindings(file: FilePIIs) {
    return (
      file.email_accounts.length > 0 ||
      file.phone_numbers.length > 0 ||
      file.other_piis.length > 0
    );
  }

  return { results, pathStatus, scanning, error, hasScanned, scan, reset, hasFindings };
}
