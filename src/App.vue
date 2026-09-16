<script setup lang="ts">
import { ref } from "vue";
import { useStepper } from "./composables/useStepper";
import { useScan } from "./composables/useScan";
import Stepper from "./components/Stepper.vue";
import ConfigureScan from "./components/configure-scan/ConfigureScan.vue";
import ScanProgress from "./components/scan-progress/ScanProgress.vue";
import ScanResults from "./components/scan-results/ScanResults.vue";
import Sidebar from "./components/sidebar/Sidebar.vue";
import GuideView from "./components/guide/GuideView.vue";
import AboutDialog from "./components/about/AboutDialog.vue";

const steps = [{ label: "Configure" }, { label: "Scan" }, { label: "Results" }];
const stepper = useStepper(steps);
const { currentIndex } = stepper;
const { results, pathStatus, scanning, error, hasScanned, scan, reset } = useScan();

const view = ref<"scan" | "guide">("scan");
const aboutOpen = ref(false);

function selectView(target: "scan" | "guide" | "about") {
  if (target === "about") {
    aboutOpen.value = true;
    return;
  }
  view.value = target;
}

async function startScan(paths: string[]) {
  stepper.goTo(1);
  await scan(paths);
  stepper.goTo(2);
}

function rescan() {
  reset();
  stepper.goTo(0);
}

function handleStepSelect(index: number) {
  if (index === 0) rescan();
}
</script>

<template>
  <div class="flex h-screen w-screen overflow-hidden bg-white font-sans text-neutral-900">
    <Sidebar :active="view" @select="selectView" />

    <main class="min-w-0 flex-1 overflow-y-auto">
      <GuideView v-if="view === 'guide'" @close="view = 'scan'" />

      <div v-else class="p-8">
        <Stepper
          class="mb-6 w-full max-w-[1440px]"
          :steps="steps"
          :state-of="stepper.stateOf"
          :current-index="currentIndex"
          @select="handleStepSelect"
        />

        <ConfigureScan v-if="!scanning && !hasScanned" @start-scan="startScan" />
        <ScanProgress v-else-if="scanning" :path-status="pathStatus" />
        <p v-else-if="error" class="mt-6 text-left text-red-600 dark:text-red-400">
          {{ error }}
        </p>
        <ScanResults v-else-if="hasScanned" :results="results" @rescan="rescan" />
      </div>
    </main>

    <AboutDialog v-if="aboutOpen" @close="aboutOpen = false" />
  </div>
</template>
