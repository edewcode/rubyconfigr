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


require 'error/IncorrectVariableError.rb'; 


module RubyConfigr
  
  # VariableReplacer is responsible for checking all the placeholder varibles. It will identify those 
  # variables and replace them either by checking against the variable values from global variables scope 
  # or local variables scope as provided.
  class VariableReplacer
  
  
    # this method will find the variables and replace them with the
    # values searched in the configuration
    # 
    # value : the value which contains the place holder 
    # from_section : may contain ':global' or ':both' symbols symbolizing as 
    #                     ':global' - check variables from global vaiables scope 
    #                     ':both' - check varaibles both from global and local scope 
    def find_and_replace(value, cfgmgr, from_section)
      
      idx = value.index('$');
      if idx != nil        
        actual_value_length = value.length;
        while idx <  actual_value_length
          if value[idx] == '$' and value[idx+1] == '{'
            
            # get the closing braces index and if it is nil then it means that there is syntax error 
            # and so raise error 
            close_brace_idx = value.index("}", idx+1);               
            if close_brace_idx == nil
              throw RubyConfigr::IncorrectVariableError.new("'}' is missing for value = #{value}");
            end # -- end if 
            
            # only the variable part or placeholder text under '${}'
            variable = value[idx+2,close_brace_idx-idx-2]; 
    
            # if from section is global then check the variables from global scope
            if from_section == :global 
              replaced_val = cfgmgr.get_global_variable_value(variable);
            
            # if from section is both global and local then check the variables from both global
            # and local scope  
            elsif from_section == :both   
              replaced_val = cfgmgr.get_variable_value(variable);
                 
            end # -- end if  
            
            tot_variable_length = variable.length + 3;   # total length of '${}' = 3 characters 
            tot_replaced_val_length = replaced_val.length;          
            value[idx, tot_variable_length] = replaced_val;    # variable text including the '${}' is replaced
            actual_value_length = actual_value_length - (variable.length + 3) + replaced_val.length;          
            idx = idx + replaced_val.length - 1;         
           
          else
            idx += 1;
          end # -- end if 
          
        end  # -- end while
      end  # -- end if 
      return value;
    end
  
  end # -- end of class

end # -- end of module RubyConfigr

