# harry

ggplot() +
  aes(x = team, y = count) +
  geom_col(fill = colour) 

# mine

ggplot() +
  aes(x = medal, y = count, fill = medal) +
  geom_col() +
  theme_light()



colour <- case_when(
  olympics_overall_medals$medals == "Gold" ~ "#C9B037",
  olympics_overall_medals$medals  == "Silver" ~ "#B4B4B4",
  olympics_overall_medals$medals  == "Bronze" ~ "#AD8A56")