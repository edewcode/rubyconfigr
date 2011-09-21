

$:.push	File.absolute_path(File.join(File.dirname(__FILE__), "..", "lib"))


ENV["mapper_path"] = "E:/MyWorkspace/rubyworkspace/config-mapper.properties";

require 'configmanager';

cfgmgr = RubyConfigr::ConfigManager.instance.get;

puts cfgmgr.to_yaml;

puts cfgmgr.get_property("sample");
puts cfgmgr.get_property("simplepath", "sample_category");
puts cfgmgr.get_property("simplepath", "sample_category");




################################################################
# This is to test whether the module CommonPropertiesFileParser
# is working accordingly or not.
################################################################

=begin

require 'parser/common_properties_file_parser';


class CommonPropertiesFileParserTest
   include CommonPropertiesFileParser

 def test_list
   file_path = "E:/MyWorkspace/rubyworkspace/config-mapper.properties";
   proplist = load_all_properties(file_path); 	 

   proplist.each do |prop|
   	  puts prop;
   	  puts "\n";
   end 

 end 

end 


obj = CommonPropertiesFileParserTest.new;
obj.test_list;

=end 




