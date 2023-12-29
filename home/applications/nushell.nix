{...}: {
  programs.nushell = {
    enable = true;
    configFile.text = ''
      let-env config = {
        show_banner: false
        table: {
          mode: rounded
          index_mode: always
          show_empty: true
        }
        completions: {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: "prefix"
          external: {
            enable: true
            max_results: 100
            completer: null
          }
        }
        file_size: {
          metric: true
          format: "auto"
        }
        bracketed_paste: true
        edit_mode: vi
        shell_integration: true
      }
    '';
  };
}
