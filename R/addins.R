#' @export
deploy_app <- function() {
  rstudioapi::sendToConsole('devtools::load_all(".")')
  rstudioapi::sendToConsole('rsconnect::deployApp(forceUpdate = TRUE)')
}

#' @export
run_app <- function() {
  rstudioapi::sendToConsole('devtools::load_all(".")')
  rstudioapi::sendToConsole('run_app()')
}

#' @export
run_shiny_mod <- function() {
  fn <- basename(rstudioapi::getSourceEditorContext()$path)
  if (str_detect(fn, "^mod_.*\\.R")) {
    rstudioapi::sendToConsole('devtools::load_all(".")')
    rstudioapi::sendToConsole(paste0(stringr::str_remove(fn, "\\.R$"), "_app()"))
  }
}


#' @export
#' @importFrom glue glue
use_shiny_mod <- function(name = NULL, open = rlang::is_interactive()) {
  fn <- glue("mod_{name}.R")
  fpath <- usethis::proj_path("R", fn)

  if(!file.exists(fpath)) {
    fileConn<-file(fpath)

    content <- glue(
      'mod_{{name}}_ui <- function(id) {',
      '  ns <- NS(id)',
      '  tagList(',
      '    ',
      '  )',
      '}',
      '',
      'mod_{{name}}_server <- function(id) {',
      '  moduleServer(',
      '    id,',
      '    function(input, output, session) {',
      '      ',
      '    }',
      '  )',
      '}',
      '',
      'mod_{{name}}_app <- function() {',
      '  ui <- fluidPage(',
      '    mod_{{name}}_ui("input"),',
      '    verbatimTextOutput("verba")',
      '  )',
      '  ',
      '  server <- function(input, output, session) {',
      '    res <- mod_{{name}}_server("input")',
      '    output$verba <- renderPrint({',
      '      res()',
      '    })',
      '  }',
      '  ',
      '  shinyApp(ui, server)',
      '}', .open = "{{", .close = "}}", .sep = "\n"
    )
    writeLines(content, fileConn)
    close(fileConn)
  }

  usethis::edit_file(fpath, open = open)
}
