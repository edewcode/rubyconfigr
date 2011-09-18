require 'test/unit';
require 'helper';

class AppTest < Test::Unit::TestCase
 
 attr_accessor :cfgmgr;
 
 def setup 
   ENV["mapper_path"] = File.join(File.dirname(__FILE__),"config-mapper.xml");
   @cfgmgr = RubyConfigr::ConfigManager.instance.get;
 end
 
 def test_default_property         
   assert_equal "root" , @cfgmgr.get_property("user"); 
 end
 
 def test_category_property
   assert_equal "user" , @cfgmgr.get_property("user","jdbc");
   assert_equal "pass" , @cfgmgr.get_property("password","jdbc");
 end
 
 def test_vars_in_property
   assert_equal "/home/dev/files" , @cfgmgr.get_property("devloc");    
 end

end

