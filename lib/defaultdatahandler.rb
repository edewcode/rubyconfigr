#Copyright 2011 edewcode.com
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


# Author:  Kartik Narayana Maringanti
# Contact: edewcode@gmail.com, mn.kartik@gmail.com



require 'variablereplacer';

module RubyConfigr
  
  
  # DefaultDataHandler is responsible for following 
  #
  # * one place to handle the parsed data from xml.
  # * store all the configuration data into ConfigManager singleton instance. 
  class DefaultDataHandler
  	
  	# Holds the ConfigManager singleton instance 
  	attr_accessor  :cfmgr;
  	
  	# Holds the VariableReplace reference 
  	attr_accessor  :variable_replacer;
  	
  	# Logger reference 
  	attr_accessor  :logger;
  	
  	@@cn = "[#{self.class.name}] "; 
  	
  	
  	def initialize
  	  @cfmgr = RubyConfigr::ConfigManager.instance.get;
  	  @variable_replacer = RubyConfigr::VariableReplacer.new;
  	  @logger = RubyConfigr::AppLogger.get_logger();	  
  	end 
  	
  	
  	# Will store the global variables in @cfmgr. If +value+ contains any other variable as '${}' then replace the variable '${}' with 
  	# the value of that variable defined under <global-varaibles>. If found then value is replaced or else empty value is returned. 	
  	# 
  	# ==== Arguments 
  	# * +name+ - name of the variable
  	# * +value+ - value of the variable  
  	def handle_global_variables(name, value)	
  	  @logger.debug("#{@cn}inside handle_global_varialbes -- [name=#{name}, value=#{value}]");
  	  	  
  	  value = @variable_replacer.find_and_replace(value, @cfmgr, :global);
  	  @cfmgr.add_global_variable(name, value);
  	  
  	  @logger.debug("#{@cn}out of handle_global_variables");
  	end 
  	
  	
  	# Will handle the configration file locations
  	#
  	# loc_path - location path of the config file
    # Will store the config xml file location in @cfmgr defined in mapper xml file. If +loc_path+ contains any other variable as '${}' then 
    # replace the variable '${}' with the value of that variable defined under <global-varaibles>. If found then value is replaced 
    # or else empty value is returned.   
    # 
    # ==== Arguments 
    # * +loc_path+ - name of config xml file location  
  	def handle_config_location(loc_path)	  
  	  @logger.debug("#{@cn}inside handle_config_location -- [loc_path=#{loc_path}]");	  
  	  
  	  value = @variable_replacer.find_and_replace(loc_path, @cfmgr, :global);	 
  	  @cfmgr.add_config_file_location(loc_path);
  	  
  	  @logger.debug("#{@cn}out of handle_config_location");
  	end
  	
  	
  	# Will handle the local variables or the <variables> defined in individual config xml file. If +value+ contains any other variable as '${}' 
  	# then replace the variable '${}' with the value of that variable defined under <global-varaibles> or <variables> of config xml file ( i.e
  	# local or global ) If found in then value is replaced with the found variable value.  
  	#
  	# ==== Arguments 
  	# * +name+ - local variable name 
  	# * +value+ - local variable value
  	def handle_local_variables(name, value)
  	  @logger.debug("#{@cn}inside handle_local_variables");
  	  
  	  value = @variable_replacer.find_and_replace(value, @cfmgr, :both);
  	  @cfmgr.add_local_variable(name, value);
  	  
  	  @logger.debug("#{@cn}out of handle_local_variables");
  	end
  	
  	
  	# Will handle the default properties <property/> or uncategorized <property>. If property +value+ contains any other variable as '${}' 
    # then replace the variable '${}' with the value of that variable defined under <global-varaibles> or <variables> of config xml file ( i.e
    # local or global ) If found in then value is replaced with the found variable value. 
    #
    # ==== Arguments 
    # * +name+ - local property name 
    # * +value+ - local property value
    def handle_default_property(name, value)
      @logger.debug("#{@cn}inside handle_default_property");
      
      value = @variable_replacer.find_and_replace(value, @cfmgr, :both);
      @cfmgr.add_default_property(name, value);
      
      @logger.debug("#{@cn}out of handle_default_property");
    end
    
    
  	
  	# Will handle the categorized properties defined under named <category>. If property +value+ contains any other variable as '${}' 
    # then replace the variable '${}' with the value of that variable defined under <global-varaibles> or <variables> of config xml file ( i.e
    # local or global ) If found in then value is replaced with the found variable value.
    #
    # ==== Arguments
    # * +category+ - name of the category 
    # * +name+ - property name 
    # * +value+ - property value
    def handle_category_property(category, name, value)
      @logger.debug("#{@cn}inside handle_category_property");
      
      value = @variable_replacer.find_and_replace(value, @cfmgr, :both);
      @cfmgr.add_category_property(category, name, value);
          
      @logger.debug("#{@cn}out of handle_category_property");
    end
    
  end #-- end of class
  
  
end #-- end of module RubyConfigr
