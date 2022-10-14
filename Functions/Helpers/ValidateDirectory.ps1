# Validator that checks if given String is an Existing Directory
$code = @'
using System;
using System.Collections.Generic;
using System.Management.Automation;

    public class ValidateDirectoryExistsAttribute : System.Management.Automation.ValidateArgumentsAttribute
    {
        protected override void Validate(object path, EngineIntrinsics engineEntrinsics)
        {
            if (string.IsNullOrWhiteSpace(path.ToString()))
            {
                throw new ArgumentNullException();
            }
            if(System.IO.File.Exists(path.ToString()))
            {
                throw new System.IO.DirectoryNotFoundException("Path is a file but must be a Directory");
            }
            if(!(System.IO.Directory.Exists(path.ToString())))
            {
                throw new System.IO.DirectoryNotFoundException("Path must be a valid Directory");
            }
        }
    }
'@

Add-Type -TypeDefinition $code