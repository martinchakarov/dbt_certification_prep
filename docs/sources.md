{% docs source_customer %}

**Description:** _Data about the shop's customers._

# This docs block shows how a description of a dbt object can be written in a separate .md file, which supports all functionalities of the Markdown syntax.

Note that the reference to this doc in your .yml file needs to point to the macro name ---> **source_customer** , not to the name of the file ~~sources.md~~.

{% enddocs %}

{% docs source_order %}

**Description:** _Data about the shop's orders._

## This docs block shows that you can have many docs blocks stored in the same .md file, even though they describe different dbt objects. 

As mentioned, you need to point to the macro name in your .yml file, not to the name of the .md file.
    
{% enddocs %}