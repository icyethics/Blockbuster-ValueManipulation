# Blockbuster-ValueManipulation

THIS IS AN ALPHA-BUILD OF THIS API. FEEDBACK IS APPRECIATED, AND FUNDAMENTAL CHANGES TO THE SET UP MAY STILL HAPPEN.

Adds a system for Value Manipulation compatibility to Balatro, intended to offer an opt-in method.

- Joker value manipulation
- Value Randomization (a la Misprinterize from Cryptid)


# Design Guidelines

To make value manipulation a consistent mechanic, this API strongly recommends you to design your jokers around these guidelines. These make it so players can more easily guess as to what your changes will result in.

- Detrimental values don't get changed. 
While value manipulation can be used detrimentally, it's most often used as a boon to the player. To make sure the intended effect is always beneficial, not every number on a joker can change. I.E. Loyalty card is set up to have the xMult given change, but not the number of hands triggered.

- Chances change to benefit the player (if possible).
Jokers that incorporate odds will often be detrimentally affected by value manipulation. 1 in 2 chances become 1 in 4 chances. This is fine for downsides, but the approach this API takes is to have the numerator change, while the determiner remains static. Vanilla jokers, and jokers that don't account for this system, don't allow for this, but by adding a specific numerator variable, the system can easily change them to benefit the player.

- Stacked values aren't changed
Stacking jokers, like Runner, Flash Card or Hologram are more interesting when they're focused on how they stack, rather on the final value they give. This is why the API recommends setting up the stacked chips, mult or xmult value to not be affected, but have earned values change. By setting it up like this, temporary value increases on stacking jokers still have a benefit, as you can use it to stack more quickly. It also prevents stacking xmult jokers from becoming generic scoring jokers, due to the base value of 1 being manipulated separately. 

# Using the Value Manipulation Functions

The main function you will be using to actually manipulate values is
```Blockbuster.manipulate_value(card, source, num, change)```

- card: the card which will have its values manipulated. (Currently, this must be a Joker)
- source: a key to store the current value manipulation from this source. 
- num: the final manipulation. This overrides previous values if present, or fully removes the entry if it's set to 1 (as value x1 would result in no manipulation)
- [OPTIONAL] change: set to true if you want the num parameter to not override, but to change the existing value, instead. If a joker already has a current x2.5 from the source 'PowerBoost', Blockbuster.manipulate_value(card, "PowerBoost", 1.1) will set it to 1.1. However, Blockbuster.manipulate_value(card, "PowerBoost", 1.1, true) will set it to 3.6.

NOTE: The current implementation only works on jokers (this hopefully will be expanded in the future), and will return false without having any effect. If you have Cryptid installed, however, Cryptid's value manipulation will be used. 



# Using a provided Compatibility Standard

Provided with the API are multiple compatibility standards (CompatStandards). These standards determine how your objects are treated by the value manipulation system. As a default, the system checks the source mod for an object, and then sees if that object has a CompatStandard registered. It's recommended to use the 'basic' CompatStandard if you want to use a default one and have not yet started writing your mod. It's strongly advised not to use the 'vanilla_base' or 'vanilla_chips' standard, as these are set up to account for the quirks of vanilla code, and incorporate hardcoded exceptions. 

To use a standard for your mod, you want to call the following function in your own code. It's adviced to include it in the start up code for your mod. 

```Blockbuster.RegisterCompatStandardWithMod(key_to_standard, mod_id)```

- key_to_standard: STRING. the key that's st for a standard. (i.e. 'basic')
- mod_id: STRING. The ID for your mod. This should match the ID set up in your mod's JSON or metadata exactly.

To use the standard in your code, you will have to follow the naming conventions that are dictated by the variable conventions table. The full_vars table includes variable names that will never be affected by value manipulation. The 'ends_on' table includes suffixes you can append to your variable names to exclude them. The 'starts_with' table includes prefixes. 

# Setting up your own Compatibility Standard

If you've already been making a mod, and don't want to rename all your variables to fit a provided standard, the best solution is to make your own. To make your own, you need to simply add a Blockbuster.ValueManipulation.CompatStandard object to your mod. By including the 'source_mod = "yourModID", in the CompatStandard, it will automatically be registered as the default standard for your mod's objects.

In the variable_conventions table, you can set up the naming conventions that are specific to your mod. 
full_vars includes the full names of variables that will never be changed. If 'odds' is included here, for example, no variable named 'odds' will ever be changed by the code. A variable named 'odds_additional', however, will. 
ends_on includes suffixes that will prevent a variable from being manipulated. 
starts_with includes prefixes that will prevent a variable from being manipulated.

To exclude a joker from your mod from even being tested, you can add its key to the exempt_jokers dictionary. This should be formatted as such

exempt_jokers = {
    j_mymod_myexemptjoker = true
}

If your mod was not prepared for this type of value manipulation, there's a chance your scaling jokers store their total stacked values in variables with the same names as those of non-scaling jokers. But it might be a lot of work to set up an individual override for every of those jokers. For this, you can set up `` redirect_objects = {}``, to redirect specific jokers to use another standard. This allows you to use multiple standards, as long as you maintain a single main one. This table should be formatted as such:

redirect_objects = {
    key_of_altCompatStandard = {
        j_mymod_myexemptjoker = true
    }
}

# Creating Object specific exceptions

Your mod may have jokers that need more specific instructions, or don't actually function easily with the standard you want to use. You can add a variable named 'bb_alternate_standard' to your joker's code, and pass a CompatStandard key. In that case, regardless of source mod, the the alternate standard will be used. 

If you want to use a standard only for one specific joker, creating a CompatStandard object might be overkill. In that case, you can use 'bb_personal_standard', and include a 'variable_conventions' table in your joker's code, which will be used instead of any existing standard.