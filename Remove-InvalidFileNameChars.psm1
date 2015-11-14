#
# Remove_InvalidFileNameChars.psm1
#

# http://stackoverflow.com/questions/23066783/how-to-strip-illegal-characters-before-trying-to-save-filenames
Function Remove-InvalidFileNameChars {
  param(
    [Parameter(Mandatory=$true,
      Position=0,
      ValueFromPipeline=$true,
      ValueFromPipelineByPropertyName=$true)]
    [String]$Name
  )

  $invalidChars = [IO.Path]::GetInvalidFileNameChars() -join ''
  $re = "[{0}]" -f [RegEx]::Escape($invalidChars)
  return ($Name -replace $re)
}

Export-ModuleMember -Function Remove-InvalidFileNameChars
