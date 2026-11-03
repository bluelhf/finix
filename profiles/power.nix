{ modules, ... }:

{
  imports = [ modules.tlp ];

  services.tlp = {
    settings = {
      INTEL_GPU_MIN_FREQ_ON_AC = 600;
    };
  };
}
