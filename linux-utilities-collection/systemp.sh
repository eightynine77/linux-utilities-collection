#!/bin/bash

# --- Default Settings ---
raw_mode=false
print_no_output=false
print_with_output=false
email_output=false
email_address=""
output_file=""

# --- Argument Parsing Loop ---
# This loop can handle arguments in any order (e.g., -r -pn or -pn -r)
while [[ $# -gt 0 ]]; do
  case "$1" in
    -r | --raw)
      raw_mode=true
      shift # Consume the argument
      ;;
    -pn | --print-nooutput)
      print_no_output=true
      shift # Consume the argument
      ;;
    -pw | --print-withoutput)
      print_with_output=true
      shift # Consume the argument
      ;;
    -eo | --email-output)
      # This argument requires a value (the email address)
      if [[ -n "$2" ]]; then
        email_output=true
        email_address="$2"
        shift 2 # Consume both the flag and the email address
      else
        echo "Error: $1 requires an email address." >&2
        exit 1
      fi
      ;;
    *)
      # Unknown argument
      echo "Error: Unknown argument '$1'" >&2
      echo "Usage: systemp [-r] [-pn | -pw] [-eo email@address.com]" >&2
      exit 1
      ;;
  esac
done

# --- Validate Argument Combinations ---

# Cannot use -pn and -pw at the same time
if $print_no_output && $print_with_output; then
  echo "Error: Cannot use -pn (--print-nooutput) and -pw (--print-withoutput) at the same time." >&2
  exit 1
fi

# Emailing requires a file to be generated
if $email_output && ! $print_no_output && ! $print_with_output; then
  echo "Error: -eo (--email-output) requires either -pn or -pw to generate a file to send." >&2
  exit 1
fi

# --- NEW: Improved 'mail' command check ---
if $email_output && ! command -v mail &> /dev/null; then
  echo "Error: 'mail' command not found. This is required for the -eo/--email-output feature." >&2
  
  # Try to detect the package manager to provide a helpful suggestion
  if command -v apt &> /dev/null; then
    echo "Suggestion: Try installing 'mailutils' with 'sudo apt install mailutils'" >&2
  elif command -v dnf &> /dev/null; then
    echo "Suggestion: Try installing 'mailutils' with 'sudo dnf install mailutils'" >&2
  elif command -v yum &> /dev/null; then
    echo "Suggestion: Try installing 'mailutils' with 'sudo yum install mailutils'" >&2
  elif command -v pacman &> /dev/null; then
    echo "Suggestion: Try installing 'mailutils' or 's-nail' (e.g., 'sudo pacman -S mailutils')" >&2
  else
    echo "Suggestion: Please install a package that provides the 'mail' command (often named 'mailutils')." >&2
  fi
  exit 1
fi

# --- Set Up File Output ---
# If either print flag is set, define a temp file name
if $print_no_output || $print_with_output; then
  # Using /tmp is standard for temporary files
  output_file="/tmp/systemp_report_$(date +'%Y-%m-%d_%H-%M-%S').txt"
fi

# --- Original Help Message ---
# Show this only if output is going to the screen (default or -pw)
# and raw_mode is not enabled.
if ! $raw_mode && ! $print_no_output; then
  echo
  echo 'Usage: systemp [-r | --raw] [-pn | -pw] [-eo email@address.com]'
  echo ''
  echo '[-r | --raw] display temperature in millidegrees'
  echo "[-pn | --nooutput] output temperature to a text file in the /tmp/ folder but doesn't display the temperature output"
  echo "[-pw | --print-withoutput] output temperature to a text file in the /tmp/ folder while also displaying the temperature output"
  echo '[-eo | --email-output] send the output file with email (this requires you to use the -pn or -pw command)'
  echo ''
  echo ''
  echo 'example:'
  echo 'systemp -pw -eo email@example.com'
  echo 'systemp -pn -eo email@example.com'
  echo ''
  echo 'NOTE: in order to use the -eo mail command, you must first install mailutils package.'
  echo 'make sure your linux distro/distribution has the mailutils package'
  echo
fi

# --- Core Logic in a Function ---
# Putting this in a function makes it easy to redirect its output
get_system_temps() {
  for i in /sys/class/thermal/thermal_zone*; do
    # Check if thermal zone exists and is readable
    if [[ -r "$i/temp" ]]; then
      temp=$(cat "$i/temp")
      zone_name=$(basename "$i")

      if $raw_mode; then
        echo "$zone_name temp: ${temp} m°C - (millidegree)"
      else
        echo "$zone_name temp: $((temp / 1000))°C"
      fi
    fi
  done
}

# --- Execute Logic & Handle Output ---
echo "Generating temperature report..." >&2 # Info message to stderr

if $print_no_output; then
  # Option 1: -pn (File Only)
  get_system_temps > "$output_file"
  echo "Report saved to $output_file" >&2
elif $print_with_output; then
  # Option 2: -pw (File and Screen)
  # 'tee' command sends output to both the file and stdout (the screen)
  get_system_temps | tee "$output_file"
  echo "Report also saved to $output_file" >&2
else
  # Option 3: Default (Screen Only)
  get_system_temps
fi

# --- Handle Emailing ---
if $email_output; then
  echo "Sending report to $email_address..." >&2
  
  # Use the 'mail' command to send the file as an attachment
  # -s = Subject
  # -A = Attach file (this flag may vary, e.g., 'mutt' uses -a)
  subject="System Temperature Report - $(date)"
  body="See attached file for the system temperature report."
  
  echo "$body" | mail -s "$subject" -A "$output_file" "$email_address"
  
  if [[ $? -eq 0 ]]; then
    echo "Email sent successfully." >&2
    # Optional: You could remove the file after sending
    # rm "$output_file"
  else
    echo "Error: Failed to send email." >&2
  fi
fi

echo "Done." >&2
