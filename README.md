# weather
C'est un projet de test technique pour la société Exomind.
Le design pattern :  MVVM + rxswift + moya

La description du projet :


1. Affiche un écran d’accueil avec un texte et un bouton.


2. Au clic sur le bouton, j’arrive sur un autre écran contenant une jauge de progression en pourcentage en bas de l’écran avec un message au-dessus.
Cette jauge doit se remplir à 100% en 60 secondes


3. Toutes les 10 secondes elle doit faire un appel à une API météo pour 5 villes : 
0 secondes Rennes, à 10 secondes Paris, à 20 secondes Nantes, etc pour Bordeaux et Lyon
(par exemple l’api https://openweathermap.org/current, ou une autre API de météo de votre choix)


4.Un message d’attente est affiché pour faire patienter l’utilisateur
 messages qui doivent tourner toutes les 6 secondes (sans limite de temps)
1)    Nous téléchargeons les données…
2)    C’est presque fini…
3)    Plus que quelques secondes avant d’avoir le résultat…
 
5. Gérer les erreurs d’API


6. Lorsque la jauge est remplie elle affiche les résultats obtenus sous forme d’un tableau de 5 lignes (une ligne par ville) sur le même écran (au-dessus de la jauge par exemple)
Afficher à minima le nom de la ville, la température, la couverture nuageuse (sous forme d’un picto par exemple)


7. La jauge se transforme en bouton « Recommencer »


8. Il est possible de faire back pour revenir à l’écran d’accueil
