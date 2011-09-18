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



require 'singleton';
require 'applogger';
require 'bootstraploader';
require 'utils/checkutils';


module RubyConfigr 
  
  # ConfigManager is a singleton class which holds the following 
  # * global varaibles configured in mapper file 
  # * config file locations configured in mapper file 
  # * default and categorized properties configured in config files
  class ConfigManager
      include Singleton
  	
  	# (Map) which holds all the global variables as name-value pair.  
  	attr_accessor :global_variables; 
  									
  	# (List) which holds all the config file absolute locations. 	
  	attr_accessor :config_files_location; 
  				         
  	# (Map) which holds both default and categorized properties.
    attr_accessor :properties;
  						 			
  	# (Map) which holds the local name value pairs 
  	# this will be cleared for each config xml since 
  	# the scope of local variables is only limited
  	# to that config file only.									
    attr_accessor :local_variables;
  									
  	
  	# Holds the singleton ConfigManager object  
  	@@cfmgr	= nil;
  	
  	# Holds the logger reference 
  	@@logger = RubyConfigr::AppLogger.get_logger;
  	
  	@@semaphore = Mutex.new(); 
  	 
  	# Always returns single instance of ConfigManager
  	#
  	# ==== Returns 
  	# * +@@cfmgr+ - ConfigManager instance 
    def get      
      if @@cfmgr == nil
        @@semaphore.synchronize{
    			@@cfmgr = ConfigManager.instance;
    			@global_variables = { };
    			@config_files_location = [];
    			@properties = {};
    			@properties["default"] = {};
    			RubyConfigr::BootstrapLoader.load;	  			
    	  }									
  		end
  		return @@cfmgr; 	  
    end 
    
    
    # Instantiate new map for local variables
    def create_local_variables_map 
      @local_variables = {};
    end
    
    
    # Clear all the local variables map 
    def clear_local_variables_map
      @local_variables.clear;
    end 
    
    
    # Adds global variables defined under <global-variables/> in mapper file 
    # to @global_variables map.
    # <b>NOTE: </b> <em> When two or more <variable> element have same 'name' attribute then this method will show a warning message </em>
    #
    # ==== Arguments 
    # * +name+ - name of the variable 
    # * +value+ - value of the variable 
  	def add_global_variable(name, value)
  	   if @global_variables[name] == nil 
  	     @global_variables[name] = value;
  	   else 	     
  	     old_value = @global_variables[name];
  		   @global_variables[name] = value;
  		   @@logger.warn("global variable '#{name}' value is overridden. [old : #{old_value}, new : #{value}] ");
  		 end 
  	end 
  	
  	
  	# Adds config file location into the array @config_files_location. If the location is not absolute this method will change the location 
  	# into an absolute one and store it in @config_files_location array.
    #
    # <b>NOTE: </b> <em> If more the one <config> has same 'location' value then warning message is shown and the duplicate locations are not 
    # insered into the array </em>
    #
    # ==== Arguments 
    # * +location+ - location of the config file    
  	def add_config_file_location(location)
  	  if not location.strip.eql?("")
  	    location = File.expand_path(location);
  	    if @config_files_location.include?(location)
  	     @@logger.warn("location = #{location} is already configured.");
  	    else 	     
         @config_files_location.push(location);   
  	    end 	    
  		else 
  		 # throw error		 
  		 @@logger.fatal("config file location is not mentioned. It cannot be empty."); 		 
  		end
  	end 
  	
  	
  	# Adds local variables defined under <variables/> and store into @local_varaibles map.  
    #
    # <b>NOTE: </b> <em> If more the one <variable> with same 'name' is configured then a warning message is shown and will override the 
    # latest <variable> 'value' against the 'name' </em> 
    #
    # ==== Arguments 
    # * +name+ - mame of the local config variable 
    # * +value+ - value of the local config variable 
  	def add_local_variable(name, value)
  	  if @local_variables[name] == nil
  	    @local_variables[name] = value;
  	  else
  	     old_value = @local_variables[name];
         @local_variables[name] = value;
         @@logger.warn("local variable '#{name}' value is overridden. [old : #{old_value}, new : #{value}] ");
  	  end 
  	end 
  	
  	
  	# Adds default property or uncategorized property mentioned in config file and store into @properties map.
  	#	
    # <b>NOTE: </b> <em> If more the one default <property> with same 'name' is configured then a warning message is shown and will 
    # override the value with the the latest <property> 'value' </em> 
    #
    # ==== Arguments 
    # * +name+ - name of the default property variable 
    # * +value+ - value of the default property variable   
  	def add_default_property(name, value)
  	  default_prop = @properties["default"];
  	  if default_prop[name] == nil 
  	   default_prop[name] = value;
  	  else 
  	   old_value = default_prop[name];
       default_prop[name] = value;
       @@logger.warn("default property '#{name}' value is overridden. [old : #{old_value}, new : #{value}] ");   
  	  end 
  	end 
  	
  
  	# Adds property defined under a category and store into @properties map.
    # 
    # <b>NOTE: </b> <em> If more the one <property> with same 'name' for same category, is configured then a warning message is shown and will 
    # override the value with the the latest <property> 'value' for that category only.</em> 
    #
    # ==== Arguments 
    # * +cat_name+ - name of the category 
    # * +prop_name+ - name of the property  
    # * +prop_value+ - value of the property  
  	def add_category_property(cat_name, prop_name, prop_value)
  	   @properties[cat_name] ||= {};             
       catprop = @properties[cat_name];
       if catprop[prop_name] == nil
        catprop[prop_name] = prop_value; 
       else 
        old_value = catprop[prop_name];
        catprop[prop_name] = prop_value;
        @@logger.warn("Value for property #{prop_name} under category #{cat_name} is overridden. [old : #{old_value}, new : #{prop_value}]");  
       end
  	end 
  
  		
  	# Return the value of the variable defined under <global-variables>. If there is no variable found then return empty value.
    # 
    # ==== Arguments
    # * +name+ - name of the variable
    #
    # ==== Return
    # * +val+ - returns global variable value      
  	def get_global_variable_value(name)
  	  val = @global_variables[name];
  	  val ||= "";
  	  return val;
  	end
  	
  		
    # Return the variable value once check is done from both local and global scope as following  
    # * check if the value is present under config file <variables>. If found it is returned.
    # * if not found from the previous step then check if the value is present under <global-variables>. If found then return the value
    # * if not found from both local and global variables then return empty ("") string
    #
    # ==== Arguments
    # * +name+ - name of the variable
    #
    # ==== Return
    # * +val+ - returns variable value 	
  	def get_variable_value(name) 
  	 val = @local_variables[name];
  	 val ||= @global_variables[name];
  	 val ||= "";
  	 return val;	 	
  	end
  	
  	
  	# Returns property value under a category.
  	#
  	# ==== Arguments 
  	# * +name+ - name of the property
  	# * +cat_name+ - by default cat_name will have 'default' as value  
  	# 
  	# ==== Returns
  	# * +prop_val+ - returns the value of the property under default category. If not found then returns ""
  	#
  	# ==== Errors
  	# * +ArgumentError+ - raised when check fails 
  	def get_property(name, cat_name="default")
  	  
  	  @@semaphore.synchronize{
    	  if name == nil     
          raise ArgumentError, "property name = #{name} cannot be nil";
        end
        if name.strip.eql?("")     
          raise ArgumentError, "property name = #{name} cannot be empty";
        end 
        if cat_name == nil     
          raise ArgumentError, "category name = #{cat_name} cannot be nil";
        end
        if cat_name.strip.eql?("")     
          raise ArgumentError, "category name = #{cat_name} cannot be empty";
        end 
        
    	  cat_prop = @properties[cat_name];
    	  if cat_prop == nil 
    	    raise ArgumentError, "category with name = #{cat_name} is not configured";
    	  end
    	  
    	  prop_val = cat_prop[name];
    	  if prop_val == nil
    	    prop_val = "";   
    	  end    
    	  return prop_val;
  	  }
  	end 
  
  end #-- end of class


end # -- end of module 




