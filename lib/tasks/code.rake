namespace :code do


  desc "Append Licence Information to all Files"
  # Please put gem 'copyright-header'
  task :license => :environment do
    require 'rubygems'
    require 'copyright_header'

    args = {
    :license => 'AGPL3',
    :copyright_software => 'Farinopoly',
    :copyright_software_description => "Fairnopoly is an open-source online marketplace.",
    :copyright_holders => ['Fairnopoly eG'],
    :copyright_years => ['2013'],
    :add_path => '.',
    :output_dir => './'
    }

    command_line = CopyrightHeader::CommandLine.new( args )
    command_line.execute

  end

  desc "Remove Licence Information from all Files"
  # Please put gem 'copyright-header'
  task :remove_license => :environment do
    require 'rubygems'
    require 'copyright_header'

    args = {
    :license => 'AGPL3',
    :copyright_software => 'Farinopoly',
    :copyright_software_description => "Fairnopoly is an open-source online marketplace.",
    :copyright_holders => ['Fairnopoly eG'],
    :copyright_years => ['2013'],
    :remove_path => '.',
    :output_dir => './'
    }

    command_line = CopyrightHeader::CommandLine.new( args )
    command_line.execute

  end

end
