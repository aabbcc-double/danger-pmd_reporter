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
    
    # Parse report file and warn to danger
    # @return [Array<String>]
    def lint
      warn "What?"
      report_file = @report_file || "app/build/reports/pmd/pmd.xml"

      puts report_file
      doc = File.open(report_file) { |f| Nokogiri::XML(f) }
      doc.xpath("//file").each { |file| 
        puts file
      }
    end

    # Ok
    # @return [Void]
    def what
      warn "What?"
    end
  end
end
