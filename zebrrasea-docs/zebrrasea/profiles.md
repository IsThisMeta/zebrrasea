# Profiles

Do you have multiple instances of modules you want to add to ZebrraSea? Profiles are the way to do this! ZebrraSea allows you to have an infinite amount of profiles, each of which can contain a whole new set of configurations for modules.

## Adding, Deleting, and Renaming Profiles

To add, delete, or rename a profile, head to Settings -> Profiles. There are a small collection of simple options on this page, each of which should be self-explanatory.

## Changing Profiles

There are multiple ways to switch profiles within ZebrraSea.

{% hint style="warning" %}
Switching profiles clears all state-stored data from memory, and all fetched data will be fully refreshed.
{% endhint %}

### Drawer

When you have more than a single profile enabled, the top header of the drawer will show the currently active profile and can be tapped to trigger a dropdown allowing you to select any profile to switch to.

When in a module and you switch to a profile that does not have the module enabled, the only option available on that page will be to return to the dashboard.

### App Bar

When on the home/base route of a module that has another instance enabled in another profile, a dropdown arrow will be displayed beside the module title in the App Bar. Simply tap the module name to get a dropdown list of profiles that have that module enabled.

Any additional profiles that do not have the module enabled will not be shown within the dropdown. If you have additional profiles but no profile has that specific module enabled, the dropdown will not be accessible.

### Settings

You can change your profile within the Settings, either by entering the "Profiles" page and selecting the enabled profile or by entering the "Configuration" page and hitting the profile icon in the App Bar.
