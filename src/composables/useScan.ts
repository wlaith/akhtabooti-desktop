import { computed, reactive, ref } from "vue";
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
  const pathErrors = reactive<Record<string, string>>({});
  const scanning = ref(false);
  const hasScanned = ref(false);

  let scanGeneration = 0;
  let cancelResolver: (() => void) | null = null;

  const allFailed = computed(() => {
    const paths = Object.keys(pathStatus);
    return paths.length > 0 && paths.every((path) => pathStatus[path] === "error");
  });

  function clearState() {
    results.value = [];
    for (const key of Object.keys(pathStatus)) delete pathStatus[key];
    for (const key of Object.keys(pathErrors)) delete pathErrors[key];
  }

  async function scan(paths: string[]) {
    if (paths.length === 0) return;

    const generation = ++scanGeneration;
    scanning.value = true;
    hasScanned.value = true;
    clearState();
    for (const path of paths) pathStatus[path] = "pending";

    const cancelled = new Promise<void>((resolve) => {
      cancelResolver = resolve;
    });

    await Promise.race([
      Promise.allSettled(
        paths.map((path) =>
          invoke<FilePIIs[]>("scan_path", { path })
            .then((found) => {
              if (generation !== scanGeneration) return;
              results.value.push(...found);
              pathStatus[path] = "done";
            })
            .catch((e) => {
              if (generation !== scanGeneration) return;
              pathStatus[path] = "error";
              pathErrors[path] = String(e);
            }),
        ),
      ),
      cancelled,
    ]);

    if (generation === scanGeneration) {
      cancelResolver = null;
      scanning.value = false;
    }
  }

  function cancelScan() {
    scanGeneration++;
    cancelResolver?.();
    cancelResolver = null;
    clearState();
    scanning.value = false;
    hasScanned.value = false;
  }

  function reset() {
    scanGeneration++;
    cancelResolver = null;
    clearState();
    scanning.value = false;
    hasScanned.value = false;
  }

  function hasFindings(file: FilePIIs) {
    return (
      file.email_accounts.length > 0 || file.phone_numbers.length > 0 || file.other_piis.length > 0
    );
  }

  return {
    results,
    pathStatus,
    pathErrors,
    scanning,
    allFailed,
    hasScanned,
    scan,
    cancelScan,
    reset,
    hasFindings,
  };
}
