import base64

from Crypto import Random
from Crypto.Cipher import DES3
from Crypto.Hash import SHA1
from DSA import dsa_sign, dsa_verify


# encrypt a b64 el valor del texto mensaje                                    confidencialidad
# encrypt a des3 el numero primo publico                                      autenticidad
# comprobacion sha1 del texto b64                                             integralidad

key = 'thisistheprivate' #clave de 16 bits
def encrypt(text, salt):

    # key = str(base64.b64encode(key.encode("utf8")))
    # print(key)
    # print(type(key))
    text64 = base64.b64encode(text.encode("utf8"))

    data = dsa_sign(256, 3072, str(text64))

    iv = Random.new().read(DES3.block_size)  # DES3.block_size==8
    cipher_encrypt = DES3.new(key, DES3.MODE_OFB, iv)
    plaintext = str(data["public"])
    encrypted_text = cipher_encrypt.encrypt(plaintext.encode("utf8"))

    h = SHA1.new()
    h.update(text64)
    sha1 = h.hexdigest()

    return {
        "sha": sha1,
        "encrypt": encrypted_text,
        "iv": iv,
        "dsa_data": {
            "public_key": encrypted_text,
            "r": data["r"],
            "s": data["s"],
            "p": data["p"],
            "q": data["q"],
            "g": data["g"]
        },
        "message": text64
    }


def decrypt(text, encrypt, sha, dsa_data, iv):
    # key = 'thisistheprivatekeyforasecuretext'
    # key = str(base64.b64encode(key.encode("utf8")))
    cipher_decrypt = DES3.new(key, DES3.MODE_OFB,iv)  # you can't reuse an object for encrypting or decrypting other data with the same key.
    decrypt=cipher_decrypt.decrypt(encrypt)
    decrypt=int(decrypt.decode("utf-8"))
    dsa_response=dsa_verify(str(text), dsa_data["r"], dsa_data["s"], dsa_data["p"], dsa_data["q"], dsa_data["g"],decrypt)
    if(not dsa_response):
        raise Exception('Fallo', 'error validacion autenticidad')

    h = SHA1.new()
    h.update(text)
    checksah = h.hexdigest()
    # print(checksah)
    if (sha != h.hexdigest()):
        raise Exception('Fallo', 'error validacion integridad')

def pretty(d, indent=0):
   for key, value in d.items():
      print('\t' * indent + str(key))
      if isinstance(value, dict):
         pretty(value, indent+1)
      else:
         print('\t' * (indent+1) + str(value))

if __name__ == '__main__':
    text = "The standard Lorem Ipsum passage, used since the 1500s" \
           "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et " \
           "dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip " \
           "ex ea commodo" \
           "consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla " \
           "pariatur." \
           "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est " \
           "laborum.\"" \
           "Section 1.10.32 of \"de Finibus Bonorum et Malorum\", written by Cicero in 45 BC" \
           "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, " \
           "totam rem aperiam, " \
           "eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam " \
           "voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui " \
           "ratione" \
           " voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci" \
           " velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem." \
           " Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea" \
           " commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil " \
           "molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?\"" \
           "translation by H. Rackham" \
           "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will " \
           "give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, " \
           "the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure," \
           " but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely " \
           "painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, " \
           "but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a" \
           " trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? " \
           "But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, " \
           "or one who avoids a pain that produces no resultant pleasure? Section 1.10.33 of \"de Finibus Bonorum et Malorum\", " \
           "written by Cicero in 45 BC At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium " \
           "voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident," \
           " similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum " \
           "facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo" \
           " minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem" \
           " quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et " \
           "molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores" \
           " alias consequatur aut perferendis doloribus asperiores repellat. 1914 translation by H. Rackham" \
           "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the" \
           " charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are" \
           " bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same" \
           " as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. " \
           "In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what " \
           "we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing " \
           "to the claims of duty or the obligations of business it will frequently occur that pleasures have to be " \
           "repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of " \
           "selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid " \
           "worse pains.\" "
    dataencrypt = encrypt(text, "")
    # print(dataencrypt)
    pretty(dataencrypt)
    decrypt(dataencrypt["message"], dataencrypt["encrypt"], dataencrypt["sha"], dataencrypt["dsa_data"],dataencrypt["iv"])



