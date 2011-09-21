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
require 'logger';

module RubyConfigr
  
  # LogConfig module is for configuration of the logger properties where in you can configure 
  # * logger level
  # * appenders 
  # * log output format
  module LogConfig
  	
  	# Returns the same logger reference after applying the necessary 
  	# properties and other logger configuration.
  	#   
  	# ==== Attributes 
  	# * +logger+ - logger reference 
  	#  
  	# ==== Return
  	# * +logger+ - same logger reference sent as argument 
  	def self.get_log_config(logger)
  	  logger = Logger.new(STDOUT);	
  	  logger.level = Logger::DEBUG;	  
  	  logger.formatter = proc { |severity, datetime, progname, msg|
       "#{datetime}: #{progname}: #{severity}: #{msg}\n"
      }
  	  return logger;
  	end 
  end #-- end module  
  
  
  
  # AppLogger is a singleton class responsible for returning single
  # configured logger reference 
  class AppLogger 
    include Singleton, LogConfig
    
    # Logger reference
    attr_accessor :logger;
    
    
    # Method will always return only one single logger reference 
    def self.get_logger() 
      @@applogger_instance ||= AppLogger.instance;	   
  	  if @logger.nil?
  	    @logger = LogConfig.get_log_config(@logger);		  
  	  end 
      return @logger;
    end
    
  end #-- end of AppLogger 

end # -- end of moudle RubyConfigr









