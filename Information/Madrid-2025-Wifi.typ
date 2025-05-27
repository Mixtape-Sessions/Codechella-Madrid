#set page(
  paper: "us-letter",
  margin: (x: 8pt, top: 0pt, bottom: 0pt),
)
#set text(font: "Poppins", size: 11pt)
#set par(leading: 0.75em)
#show par: set block(spacing: 1.2em)
#show heading: set block(above: 32pt, below: 16pt)
#show link: it => underline(stroke: 1.5pt + rgb("#e63274"), it)


// #place(top + center)[
//   #block(width: 100% + 16pt, inset: 0pt)[
//     #box(height: 4pt, width: (100%), fill: rgb("#00B7FF"))
//   ]
// ]

#v(10pt)
#figure(image(width: 100%, "../img/banner_cropped.png"))

#align(center)[
  #text(fill: rgb("#4DCDFF"), size: 20pt, weight: "bold")[Mixtape Sessions and CUNEF Universidad present]
  #v(-8pt)
  #text(fill: rgb("#00B7FF"), size: 20pt, weight: "bold", font: "Permanent Marker")[our 2nd Annual]
  #h(8pt)
  #text(fill: rgb("#00B7FF"), size: 30pt, weight: "bold", font: "Permanent Marker")[CodeChella Madrid]
]

#v(40pt)
#align(center)[#block(width: 500pt)[#align(start)[
  #v(10pt)
  #align(center)[
    #text(size: 36pt, fill: rgb("#FF3881"), weight: 600)[WIFI: CUNEF Invitados]
    
    #text(size: 24pt)[No password]
  ]
]]]

#place(bottom + center)[
  #block(width: 100% + 24pt, inset: 0pt)[
    #box(height: 6pt, width: 25%, fill: rgb("#FF3881"))
    #h(-4pt)
    #box(height: 6pt, width: 60%, fill: rgb("#00B7FF"))
    #h(-4pt)
    #box(height: 6pt, width: 15%, fill: rgb("#FFAF18"))
  ]
]



