{ pkgs, ... }:

let
  # 1. Point to your local files. 
  # These paths are relative to where this piper.nix file is.
  voiceModel = ./voices/en_US-amy-mediumw.onnx;
  voiceConfig = ./voices/en_US-amy-medium.onnx.json;

  # 2. The script that runs Piper and pipes it to PipeWire
  piper-wrapper = pkgs.writeShellScriptBin "piper-wrapper" ''
    ${pkgs.piper-tts}/bin/piper \
      --model ${voiceModel} \
      --config ${voiceConfig} \
      --output_raw | \
      ${pkgs.pipewire}/bin/pw-play --rate 22050 --channels 1 --format s16le -
  '';
in
{
  # Enable Speech Dispatcher
  services.speechd.enable = true;

  # Add the wrapper and piper to system packages
  environment.systemPackages = [ 
    pkgs.piper-tts 
    piper-wrapper 
  ];

  # Configure the generic module
  environment.etc."speech-dispatcher/modules/piper-generic.conf".text = ''
    GenericExecuteSynth "echo \"$DATA\" | ${piper-wrapper}/bin/piper-wrapper"
    GenericCmdDependency "${pkgs.piper-tts}/bin/piper"
    GenericCmdDependency "${pkgs.pipewire}/bin/pw-play"
    
    AddVoice "en-US" "female" "piper-amy"
    DefaultVoice "piper-amy"
  '';

  # Append to speechd.conf
  environment.etc."speech-dispatcher/speechd.conf".text = pkgs.lib.mkAfter ''
    AddModule "piper" "sd_generic" "piper-generic.conf"
    DefaultModule piper
  '';
}