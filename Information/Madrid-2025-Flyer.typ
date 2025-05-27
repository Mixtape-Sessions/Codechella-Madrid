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

#align(center)[#block(width: 500pt)[#align(start)[
  #v(20pt)
  #text(size: 14pt)[
    Join Scott Cunningham and a select group of other instructors in Madrid this spring for our second annual in-person workshop! CUNEF Universidad and Mixtape Sessions are teaming up to host on May 27th-30th, 2025. This workshop will dive deep into the intricacies of difference-in-differences and synthetic control estimators, with a strong focus on practical tips and hands-on coding implementations. 
    
    Whether you're a seasoned data analyst or just starting out, this event promises to equip you with valuable knowledge and skills. Don't miss out on this exciting opportunity to enhance your understanding and application of these advanced statistical methods. Register now to secure your spot at this not-to-be-missed workshop in the vibrant city of Madrid!
  ]

  #v(10pt)
  #text(size: 18pt, fill: rgb("#FF3881"), weight: 600)[
    #align(center)[
      https://www.mixtapesessions.io/madrid/
    ]
  ]

  #v(20pt)
  #grid(
    columns: (auto, 1fr),
    gutter: 14pt,
    text(weight: "bold", size: 15pt)[Dates:], text(weight: 300, size: 15pt)[May 27th-30th, 2025],
    text(weight: "bold", size: 15pt)[Times:], text(weight: 300, size: 15pt)[9am-5pm (GMT+1) with a 1.5 hour lunch break],
    text(weight: "bold", size: 15pt)[Location:], text(weight: 300, size: 15pt)[Audtiorium at CUNEF Universidad],
  )
]]]

#place(bottom + center)[
  #block(width: 100% + 24pt, inset: 0pt)[
    #box(height: 6pt, width: (25%), fill: rgb("#FF3881"))
    #h(-4pt)
    #box(height: 6pt, width: (60%), fill: rgb("#00B7FF"))
    #h(-4pt)
    #box(height: 6pt, width: (15%), fill: rgb("#FFAF18"))
  ]
]


