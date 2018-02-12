require 'nokogiri'

module Danger
  # This is your plugin class. Any attributes or methods you expose here will
  # be available from within your Dangerfile.
  #
  # To be published on the Danger plugins site, you will need to have
  # the public interface documented. Danger uses [YARD](http://yardoc.org/)
  # for generating documentation from your plugin source, and you can verify
  # by running `danger plugins lint` or `bundle exec rake spec`.
  #
  # You should replace these comments with a public description of your library.
  #
  # @example Ensure people are well warned about merging on Mondays
  #
  #          my_plugin.warn_on_mondays
  #
  # @see  Shakhzod Ikromov/danger-pmd_reporter
  # @tags monday, weekends, time, rattata
  #
  class DangerPmdReporter < Plugin

    # Actual generated XML report file.
    # Defaults to "app/build/reports/pmd/pmd.xml"
    # @return   [String]
    attr_accessor :report_file

    # Root of project. 
    # Defaults to Dir.pwd + "/"
    # @return [String]
    attr_accessor :project_root
    
    # Parse report file and warn to danger
    # @return [Array<String>]
    def lint
      report_file = @report_file || "app/build/reports/pmd/pmd.xml"
      project_root = @project_root || Dir.pwd

      puts report_file
      doc = File.open(report_file) { |f| Nokogiri::XML(f) }
      doc.xpath("//file").each { |file| 
        file.xpath("//violation").each { |violation| 
          warning_text = violation.content
          warning_line = violation.attr("beginline")
          warning_file = file.attr("name").sub(project_root + "/", "")

          warn(warning_text, file: warning_file, line: warning_line) 
        }
      }
    end
  end
end
