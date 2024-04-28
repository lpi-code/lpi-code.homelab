from authentik.core.models import Group
str_list = context["flow_plan"].context["prompt_data"]["groups"]
groups = []
for gr_to_create in str_list:
  group, _ = Group.objects.get_or_create(name=gr_to_create)
  # ["groups"] *must* be set to an array of Group objects, names alone are not enough.
  groups.append(group)
request.context["flow_plan"].context["groups"] = groups
return True