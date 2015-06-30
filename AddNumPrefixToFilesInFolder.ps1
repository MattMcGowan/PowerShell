# Prefixes all files in a given folder with a sequential three digit number and period
# E.g.
# Before: C:\Users\firstname.lastname\Desktop\image.jpg
# After:  C:\Users\firstname.lastname\Desktop\001.image.jpg
# TODO: Error handling
# TODO: Implement RegEx check before removing prefix

# Folder path
$path = 'C:\Users\matt.mcgowan\Desktop\Test001'

# Prefix number start point
$prefix = 25

# Remove existing 4 char prefix?
$removePrefix = $true
# e.g. true if names '024.FileName.txt' to be renamed '001.FileName.txt'
# instead of '001.024.FileName.txt'


##############################
# STEP 1
# Create a random string prefix unique* to this run
##############################

# *Highly likely to be unique between runs, not guaranteed unique
# Helps avoid renaming a file to a name that already exists in the folder
# Will be the same for all files in a given run


# $charset will contain characters on which to draw from
$charset = $NULL;

# Add decimal characters
For ($a = 0; $a -le 9; $a++)
{
    $charset += ,$a
}

# Add alphabet characters
For ($a=65;$a –le 90;$a++) 
{
    $charset += ,[char][byte]$a 
}

# Get random characters from $charset
Function RandomString()
{
    $retval = $NULL;
    For ($a = 0; $a -le 9; $a++)
    {
        $retval += ($charset | GET-RANDOM)
    }

    return $retval
}

# Generate the random prefix
$namePrefix = RandomString


##############################
# STEP 2
# Add the random prefix
##############################


#Put zzz at beginning of each filepath
#Helps avoid a later file with same name from preventing a rename
$files = Get-ChildItem $path
ForEach ($file in $files){
    Rename-Item -Path $file.FullName -NewName (
            $namePrefix + $file.Name)}


##############################
# STEP 3
# Rename the files
##############################


# Set value to remove just random prefix
# or existing numeric prefix as well
If ($removePrefix) {
    $substringStart = 14
}
else-if (!$removePrefix) {
    $substringStart = 10
}
else {
    throw "Please set $removePrefix in file."
}


#Remove the random prefix (and current numeric prefix if neccessary)
#Add new numeric prefix, starting at $prefix
$files = Get-ChildItem $path
ForEach ($file in $files){
    Rename-Item -Path $file.FullName -NewName (
            $prefix.ToString("000") + "." + $file.Name.Substring(10))
    $prefix++}