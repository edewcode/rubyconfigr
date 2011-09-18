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


require 'error/parsererror';

module RubyConfigr

  module Utils
    
    
    # CheckUtils is a utility class having class methods for following 
    # 
    # * check for mandatory attribute 
    # * check for attribute having non empty value
    #
    class CheckUtils
      
      # Checks whether the element attribute is not nil
      #
      # ==== Arguments 
      # * +attr_name+ - attribute name 
      # * +ele_node+ - xml element node
      # * +err_msg+ - error message when check fails
      # 
      # ==== Errors
      # * +ParserError+ - raised when the check fails   
      def self.mandatory_attr(attr_name, ele_node, err_msg)
        if ele_node[attr_name] == nil
          raise RubyConfigr::ParserError , err_msg;
        end
      end
    
    
      # Checks whether the element attribute value is non empty
      #
      # ==== Arguments 
      # * +attr_name+ - attribute name 
      # * +ele_node+ - xml element node
      # * +err_msg+ - error message when check fails
      # 
      # ==== Errors
      # * +ParserError+ - raised when the check fails 
      def self.attr_value_not_empty(attr_name, ele_node, err_msg)
        if ele_node[attr_name].strip.eql?("")
          raise RubyConfigr::ParserError , err_msg;
        end
      end
      
    
    end #-- end of class
     
  end # -- end module Utils 

end #-- end module RubyConfigr